MODULE MainRoutine
    ! This is the main module for the robot motion task
    ! Joseph Salim
    ! 171115
    
    PERS socketstatus status;
    PERS string received_str;   
    PERS num ready;   
    PERS num VESready;
    
    !Movement Queue
    CONST num MaxQueueConst := 50;
    PERS num CommandModeQueue{MaxQueueConst};
    PERS num ModeQueue{MaxQueueConst};
    PERS pos PosQueue{MaxQueueConst};
    PERS orient OrientQueue{MaxQueueConst};
    PERS num QCount;
    PERS num ExeQ := 0;
    PERS num MaxQueue;

    ! for interupt and restart robot pos
    VAR intnum RestartRobot;
    PERS num ResetFlag;
    VAR errnum err_move_stop := -1;
    
    ! This function processes the received string from MatLab.
    ! It then calls corresponding functions based on the command received
    PROC Main()
        ! comms variable
        VAR bool ok;        
        VAR num count := 0;
        VAR num lastCnt;
        VAR string strChk;
        VAR num showMessage := 0;
        VAR num stringLen;
        
        ! for data structuring
        VAR num header;
        VAR num linJog;
        VAR robjoint jAng;
        VAR jointtarget jJog;
        VAR num RobotMode;
        VAR num PresetPos;
        
        ! for pose setting
        VAR num movMode; !linear or joint
        VAR num UpDown; ! pick up or drop block
        VAR string speedStr;
        VAR speeddata speedSet;
        VAR pos robPos;
        VAR orient robOrient;
        
        ! for restarting robot pos
        BookErrNo err_move_stop;
        CONNECT RestartRobot WITH go_to_home_pos;
        IPers ResetFlag,RestartRobot;
        
        ! initialise global variables
        QCount := 0;
        ready := 0;
        VESready := 0;
               
        
        WHILE status = SOCKET_CONNECTED DO            
            
            WaitUntil VESReady = 1;
            WaitUntil ready = 1;
            WaitUntil QCount > 0;
            IF QCount > 0 THEN
                TEST CommandModeQueue{1}
                    CASE 6:
                        ! Preset Movements
                        TEST ModeQueue{1}
                            CASE 0:
                                GoHome;                             
                            CASE 1:
                                MoveTableHome;                      
                            CASE 2:
                                MoveConveyorHome;                                             
                            CASE 3:
                                MoveConveyorBlock;        
                        ENDTEST
                 
                    CASE 7:
                        IF ModeQueue{1} = 1 THEN
                            PickBlock PosQueue{1}.x, PosQueue{1}.y, PosQueue{1}.z, OrientQueue{1};
                        ENDIF
                        IF ModeQueue{1} = 0 THEN
                            DropBlock PosQueue{1}.x, PosQueue{1}.y, PosQueue{1}.z, OrientQueue{1};
                        ENDIF
                    
                ENDTEST
                
                IF QCount > 0 THEN
                    ! Shift the queue -1 
                    FOR i FROM 1 TO (QCount) DO
                        IF QCount < MaxQueue THEN
                            CommandModeQueue{i} := CommandModeQueue{i+1};
                            ModeQueue{i} := ModeQueue{i+1};
                            PosQueue{i} := PosQueue{i+1};
                            OrientQueue{i} := OrientQueue{i+1};  
                        ENDIF                    
                    ENDFOR
                    CommandModeQueue{QCount} := 0;
                    ModeQueue{QCount} := 0;
                    PosQueue{QCount} := [0,0,0];
                    OrientQueue{QCount} := [0,0,0,0];
                    QCount := QCount - 1;
                    IF QCount = 0 THEN
                        ready := 0;
                    ENDIF
                ENDIF
                                
            ENDIF
            

            IF status = SOCKET_CONNECTED THEN
                !TPWrite "Socket connected";
            ELSEIF status = SOCKET_CLOSED THEN
                TPWrite "Socket closed";
            ELSE
                TPWrite "Unknown socket status";
            ENDIF
         ENDWHILE
         
        ! delete interrupt to clean the one used in this PROC
        IDelete RestartRobot;
        ERROR (err_move_stop)
            StartMove;
            TRYNEXT;
        
    ENDPROC		
    
    !PROC RestartMain()
     !   BookErrNo err_move_stop;
      !  Main;

    !ENDPROC
        
    TRAP go_to_home_pos
        StopMove;
        ClearPath;
        !IDelete RestartRobot;
        StorePath;
        MoveTableHome;
        RestoPath;
        RAISE err_move_stop;
        ERROR
            RAISE;
    ENDTRAP
    
ENDMODULE