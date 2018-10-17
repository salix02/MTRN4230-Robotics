MODULE CommOut
    ! This module deals with checking the heartbeat of the system and also
    ! sending out information of robot's status
    ! Joseph Salim
    ! 171115
    
    PERS num QCount;
    
    VAR socketdev client_socket;
    VAR socketstatus status;
    VAR string received_str;  
    VAR num ready := 0;
    
    ! The host and port that we will be listening for a connection on.
    ! CONST string host := "192.168.125.1";
     CONST string host := "127.0.0.1";

    
    CONST num port := 1026;
    
    ! this is the main function for the commout routine
    PROC Main()
        VAR string strStore;
        VAR num RobotMode;
        VAR bool ok;        
        VAR num count := 0;
        VAR num lastCnt;
        VAR string strChk;
        VAR jointtarget currJointPos;
        VAR robtarget currPos;
        VAR num IOstate{13};
        VAR string sendStore;
        VAR string IOString;
        VAR string JString;
        VAR string PString;
        VAR num header;
        VAR num heartBeatCnt;
        VAR num msgDecPlaces := 4;
        VAR bool pause := FALSE;
        
        ! create and connect to tcp socket
        ListenForAndAcceptConnection;
        
        status := SocketGetStatus(client_socket);
        
        WHILE status = SOCKET_CONNECTED DO
            ! Receive a string from the client.
            
            SocketReceive client_socket \Str:=strStore \ReadNoOfBytes:=1 \Time:=WAIT_MAX;
            received_str := strStore;
            
            ok := StrToVal(StrPart(received_str,1,1),header);
            
            ! count heartbeat to check how long time has gone since last poll
            heartBeatCnt := heartBeatCnt + 1;
            IF heartBeatCnt > 2500 THEN
                TPWrite "Comms disconnected";
            ENDIF
            
            ! Pause Restart Signal
            !IF VES = 0 THEN
            !        pause := TRUE;
            !        StopMove;
            !    ELSEIF pause = TRUE AND VES = 1 THEN
            !        pause := FALSE;
            !        StartMove;
            !ENDIF
                        
            IF ok = TRUE THEN
                IF header = 1 THEN
                    ! reset heartbeat
                    heartBeatCnt := 0;
                    
                    ! obtain current robot information
                    currJointPos := CJointT();
                    currPos := CRobT(\Tool:=tSCup \WObj:= wobj0);
                    IOstate{1} := DI10_1;
                    IOstate{2} := Doutput(DO10_1);
                    IOstate{3} := Doutput(DO10_2);
                    IOstate{4} := Doutput(DO10_3);
                    IOstate{5} := Doutput(DO10_4);
                    IOstate{6} := VES; !Emergency Stop
                    IOstate{7} := VGS; !Light curtain
                    IOstate{8} := VEN; !Hold to enable
                    IOstate{9} := Doutput(DO_MOTON);
                    IOstate{10} := Doutput(DO_MOTTRIG);
                    IOstate{11} := Doutput(DO_EXERR);
                    IOstate{12} := Doutput(DO_TASKEX);
                    IOstate{13} := Doutput(MOV);
                    
                    IF QCount > 0 THEN
                        IOstate{13} := 0;
                    ENDIF                 
                    
                    ! pack robot stats into strings
                    IOString := ValToStr(IOstate{1}) + "_";
                    IOString := IOString + ValToStr(IOstate{2}) + "_";
                    IOString := IOString + ValToStr(IOstate{3}) + "_";
                    IOString := IOString + ValToStr(IOstate{4}) + "_";
                    IOString := IOString + ValToStr(IOstate{5}) + "_";
                    IOString := IOString + ValToStr(IOstate{6}) + "_";
                    IOString := IOString + ValToStr(IOstate{7}) + "_";
                    IOString := IOString + ValToStr(IOstate{8}) + "_";
                    IOString := IOString + ValToStr(IOstate{9}) + "_";
                    IOString := IOString + ValToStr(IOstate{10}) + "_";
                    IOString := IOString + ValToStr(IOstate{11}) + "_";
                    IOString := IOString + ValToStr(IOstate{12}) + "_";
                    IOString := IOString + ValToStr(IOstate{13}) + "_";
                    
                    !JString := ValToStr(currJointPos.robax)+ "_";
                    !Trunc values instead
                    JString := "[";
                    JString := JString + ValToStr(Trunc(currJointPos.robax.rax_1\Dec:=msgDecPlaces)) + ",";
                    JString := JString + ValToStr(Trunc(currJointPos.robax.rax_2\Dec:=msgDecPlaces)) + ",";
                    JString := JString + ValToStr(Trunc(currJointPos.robax.rax_3\Dec:=msgDecPlaces)) + ",";
                    JString := JString + ValToStr(Trunc(currJointPos.robax.rax_4\Dec:=msgDecPlaces)) + ",";
                    JString := JString + ValToStr(Trunc(currJointPos.robax.rax_5\Dec:=msgDecPlaces)) + ",";
                    JString := JString + ValToStr(Trunc(currJointPos.robax.rax_6\Dec:=msgDecPlaces));
                    JString := JString + "]_";

                    !PString := ValToStr(currPos.trans) + "_" + ValToStr(currPos.rot);! + "\0A";
                    PString := "[";
                    PString := PString + ValToStr(Trunc(currPos.trans.x\Dec:=msgDecPlaces)) + ",";
                    PString := PString + ValToStr(Trunc(currPos.trans.y\Dec:=msgDecPlaces)) + ",";
                    PString := PString + ValToStr(Trunc(currPos.trans.z\Dec:=msgDecPlaces));
                    PString := PString + "]_[";
                    PString := PString + ValToStr(Trunc(currPos.rot.q1\Dec:=msgDecPlaces)) + ",";
                    PString := PString + ValToStr(Trunc(currPos.rot.q2\Dec:=msgDecPlaces)) + ",";
                    PString := PString + ValToStr(Trunc(currPos.rot.q3\Dec:=msgDecPlaces)) + ",";
                    PString := PString + ValToStr(Trunc(currPos.rot.q4\Dec:=msgDecPlaces));
                    PString := PString + "]";
                    
                    !sendStore := IOString + JString + PString;
                    
                    !SocketSend client_socket \Str:=(sendStore);
                    SocketSend client_socket \Str:=(IOString);
                    SocketSend client_socket \Str:=(JString);
                    SocketSend client_socket \Str:=(PString);
                    
                    ! recheck current socket status
                    status := SocketGetStatus(client_socket);
                
                ENDIF
            ENDIF
        ENDWHILE       
        
        CloseConnection;
        
    ENDPROC
    
    PROC ListenForAndAcceptConnection()
        
        ! Create the socket to listen for a connection on.
        VAR socketdev welcome_socket;
        SocketCreate welcome_socket;
        
        ! Bind the socket to the host and port.
        SocketBind welcome_socket, host, port;
        
        ! Listen on the welcome socket.
        SocketListen welcome_socket;
        
        ! Accept a connection on the host and port.
        SocketAccept welcome_socket, client_socket;
        
        ! Close the welcome socket, as it is no longer needed.
        SocketClose welcome_socket;
        
    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        SocketClose client_socket;
    ENDPROC
    
ENDMODULE