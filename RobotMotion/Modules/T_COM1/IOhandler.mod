MODULE IOhandler
    ! This module deals with setting the IOs to 1 and 0
    ! Joseph Salim
    ! 171115
    
    ! This function checks what IO states need to be changed and calls 
    ! corresponding functions to set them
    PROC IORoutine(VAR num Dev, VAR num ioStat)
        
        IF Dev = 1 THEN
            IF ioStat = 1 THEN
                TurnVacOn;
            ELSE
                TurnVacOff;
            ENDIF            
        ELSEIF Dev = 2 THEN
            IF ioStat = 1 THEN
                Turn2On;
            ELSE
                Turn2Off;
            ENDIF  
        ELSEIF Dev = 3 THEN
            IF ioStat = 1 THEN
                TurnConOnSafely;
            ELSE
                TurnConOff;
            ENDIF  
        ELSEIF Dev = 4 THEN
            IF ioStat = 1 THEN
                Turn4On;
            ELSE
                Turn4Off;
            ENDIF  
        ENDIF
        
        
        !TurnVacOn;
        
        ! Time to wait in seconds.
        !WaitTime 2;
        
        !TurnVacOff;
        
        !TurnConOnSafely;
        
        !WaitTime 2;
        
        !TurnConOff;
        
        
        
    ENDPROC
    
    ! This function sets output 1/ Vac to 1
    PROC TurnVacOn()
        
        ! Set VacRun on.
        SetDO DO10_1, 1;
        
    ENDPROC
    
    ! This function sets output 1/Vac to 0
    PROC TurnVacOff()
        
        ! Set VacRun off.
        SetDO DO10_1, 0;
        
    ENDPROC

    ! This function sets output 2 to 1
    PROC Turn2On()
        
        ! Set VacRun on.
        SetDO DO10_2, 1;
        
    ENDPROC
    
    ! This function sets output 2 to 1
    PROC Turn2Off()
        
        ! Set VacRun off.
        SetDO DO10_2, 0;
        
    ENDPROC  
    
    ! This function sets output 4 to 1
    PROC Turn4On()
        
        ! Set VacRun on.
        SetDO DO10_4, 1;
        
    ENDPROC
    
    ! This function sets output 4 to 0
    PROC Turn4Off()
        
        ! Set VacRun off.
        SetDO DO10_4, 0;
        
    ENDPROC 
    
    ! This function sets output 3 to 1 in a safe manner by checking constat
    PROC TurnConOnSafely()
        
        ! An example of how an IF statement is structured.
        ! DI10_1 is 'ConStat', and will only be equal to 1 if the conveyor is on and ready to run.
        ! If it is ready to run, we will run it, if not, we will set it off so that we can fix it.
        IF DI10_1 = 1 THEN
            SetDO DO10_3, 1;
        ELSE
            SetDO DO10_3, 0;
        ENDIF
        
    ENDPROC
    
    ! This function sets output 3 to 0
    PROC TurnConOff()
        SetDO DO10_3, 0;
    ENDPROC
    
ENDMODULE