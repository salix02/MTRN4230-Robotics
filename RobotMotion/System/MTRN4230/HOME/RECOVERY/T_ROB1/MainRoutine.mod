MODULE MainRoutine
    ! This is the main module for the robot motion task
    ! Joseph Salim
    ! 170909
    
    PERS socketstatus status;
    PERS string received_str;   
    PERS num ready;   

    ! for interupt and restart robot pos
    VAR intnum intno1;
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
        CONNECT intno1 WITH go_to_home_pos;
        IPers ResetFlag,intno1;
               
        
        WHILE status = SOCKET_CONNECTED DO
        
            WaitUntil ready = 1;
            
            ready := 0;
            count := 0;
                
            IF status = SOCKET_CONNECTED THEN           
                IF received_str <> "" THEN
                    !TPWrite received_str;
                    
                    ok := StrToVal(StrPart(received_str,1,1),header);
                    
                    
                    IF ok = TRUE THEN
                        
                        TEST header

                        CASE 1:
                        ! for linear jogging
                            ok := StrToVal(StrPart(received_str,3,1),linJog);
                            WHILE linjog <> 0 DO
                                ok := StrToVal(StrPart(received_str,3,1),linJog);
                                LinearJogRoutine(linJog);
                            ENDWHILE
                        CASE 2:
                        ! for Joint jogging
                            stringLen := StrLen(received_str); 
                            ok := StrToVal(StrPart(received_str,3,(stringLen-2)),jAng);
                            jJog.robax := jAng;
                            jJog.extax := [9E9, 9E9, 9E9, 9E9, 9E9, 9E9];
                            MoveJointAng(jJog);     
                                        
                        CASE 3:
                            ! for Move to point
                            ! initialise
                            strChk := "";
                            
                            IF showMessage = 1 THEN
                                TPWrite "Start Case 3";
                                TPWrite received_str;
                            ENDIF
                            
                            stringLen := StrLen(received_str);
                            received_str := StrPart(received_str,3,(stringLen-2));

                            
                            
                            WHILE (strChk = "_") = FALSE DO
                                TPWrite "POTATO";
                                count := count + 1; 
                                strChk := StrPart(received_str,count,1);             
                            ENDWHILE                    
                                 
                            !store the movement mode from string 
                            !count-1 because we don't want the underscore
                            
                            IF showMessage = 0 THEN
                                TPWrite received_str;
                                TPWrite ValToStr(count);
                                TPWrite ValToStr(movMode);
                            ENDIF
                            
                                                
                            ok := StrToVal(StrPart(received_str,1,count-1),movMode);
                            !where the next part of message is being read
                            lastCnt := count + 1;  
                            
                            IF showMessage = 1 THEN
                                TPWrite ValToStr(movMode);
                            ENDIF
                            ! robot speed component
                            strChk := "";
                            WHILE (strChk = "_") = FALSE DO
                                count := count + 1; 
                                strChk := StrPart(received_str,count,1);
                            ENDWHILE
                                
                            speedStr := (StrPart(received_str,lastCnt,(count-lastCnt)));
                            ok := StrToVal(speedStr,speedSet.v_tcp);
                            speedSet.v_ori := 500;
                            speedSet.v_leax := 5000;
                            speedSet.v_reax := 1000;
                            
                            TPWrite "speed str";
                            TPWrite speedStr;
                            
                            lastCnt := count + 1;
                            
                            strChk := "";
                            ! robot position component                   
                            WHILE (strChk = "_") = FALSE DO
                                incr count; 
                                strChk := StrPart(received_str,count,1);
                            ENDWHILE
                            ok := StrToVal(StrPart(received_str,lastCnt,(count-lastCnt)),robPos);
                            
                            TPWrite "Rob Pos";
                            TPWrite StrPart(received_str,lastCnt,(count-lastCnt));
                            TPWrite ValToStr(robPos);
                            lastCnt := count + 1;
                            
                            
                            ! last part of the string
                            !stringLen := StrLen(received_str); 
                            ok := StrToVal(StrPart(received_str,lastCnt,(StrLen(received_str)-lastCnt+1)),robOrient);
                            TPWrite ValToStr(robOrient);
                            
                            MoveToPos movMode, speedSet, robPos, robOrient;
                         
                         CASE 4:
                         ! Digital I/O device
                         ! handled directly in comms
                         
                         
                         CASE 5:
                         ! Pause Restart Signal
                         ! handled directly in comms
                         
                         CASE 6:
                            ! Move to Preset Position
                            ok := StrToVal(StrPart(received_str,3,1),PresetPos);
                            IF PresetPos = 0 THEN
                                GoHome;                      
                            ENDIF
                            IF PresetPos = 1 THEN
                                MoveTableHome;                      
                            ENDIF
                            IF PresetPos = 2 THEN
                                MoveConveyorHome;                      
                            ENDIF
                            IF PresetPos = 3 THEN
                                MoveConveyorBlock;
                            ENDIF
                         
                        CASE 7:
                            ! for Move to point
                            ! initialise
                            strChk := "";
                            
                            IF showMessage = 1 THEN
                                TPWrite "Start Case 3";
                                TPWrite received_str;
                            ENDIF
                            
                            stringLen := StrLen(received_str);
                            received_str := StrPart(received_str,3,(stringLen-2));

                            
                            
                            WHILE (strChk = "_") = FALSE DO
                                TPWrite "POTATO";
                                count := count + 1; 
                                strChk := StrPart(received_str,count,1);             
                            ENDWHILE                    
                                 
                            !store the movement mode from string 
                            !count-1 because we don't want the underscore
                            
                            IF showMessage = 0 THEN
                                TPWrite received_str;
                                TPWrite ValToStr(count);
                                TPWrite ValToStr(UpDown);
                            ENDIF
                            
                                                
                            ok := StrToVal(StrPart(received_str,1,count-1),UpDown);
                            !where the next part of message is being read
                            lastCnt := count + 1;  
                            
                            IF showMessage = 1 THEN
                                TPWrite ValToStr(UpDown);
                            ENDIF
                            ! robot speed component
                            strChk := "";
                            WHILE (strChk = "_") = FALSE DO
                                count := count + 1; 
                                strChk := StrPart(received_str,count,1);
                            ENDWHILE
                                
                            speedStr := (StrPart(received_str,lastCnt,(count-lastCnt)));
                            ok := StrToVal(speedStr,speedSet.v_tcp);
                            speedSet.v_ori := 500;
                            speedSet.v_leax := 5000;
                            speedSet.v_reax := 1000;
                            
                            TPWrite "speed str";
                            TPWrite speedStr;
                            
                            lastCnt := count + 1;
                            
                            strChk := "";
                            ! robot position component                   
                            WHILE (strChk = "_") = FALSE DO
                                incr count; 
                                strChk := StrPart(received_str,count,1);
                            ENDWHILE
                            ok := StrToVal(StrPart(received_str,lastCnt,(count-lastCnt)),robPos);
                            
                            TPWrite "Rob Pos";
                            TPWrite StrPart(received_str,lastCnt,(count-lastCnt));
                            TPWrite ValToStr(robPos);
                            lastCnt := count + 1;
                            
                            
                            ! last part of the string
                            !stringLen := StrLen(received_str); 
                            ok := StrToVal(StrPart(received_str,lastCnt,(StrLen(received_str)-lastCnt+1)),robOrient);
                            TPWrite ValToStr(robOrient);
                            
                            ! if pickup
                            IF UpDown = 1 THEN
                                PickBlock robPos.x, robPos.y, robPos.z, robOrient;
                            ENDIF
                            IF UpDown = 0 THEN
                                DropBlock  robPos.x, robPos.y, robPos.z, robOrient;
                            ENDIF                     
                                
                        ENDTEST
                    ENDIF           
                    
                ENDIF       
                    
                IF status = SOCKET_CONNECTED THEN
                    !TPWrite "Socket connected";
                ELSEIF status = SOCKET_CLOSED THEN
                    TPWrite "Socket closed";
                ELSE
                    TPWrite "Unknown socket status";
                ENDIF
             ENDIF   
             
             
         ENDWHILE
        
            ERROR (err_move_stop)
                StopMove;
                ClearPath;
                StorePath;
                GoHome;
                RestoPath;
                StartMove;
                RETRY;
    ENDPROC		
    
    TRAP go_to_home_pos
        RAISE err_move_stop;
        ERROR
            RAISE;
    ENDTRAP
    
ENDMODULE