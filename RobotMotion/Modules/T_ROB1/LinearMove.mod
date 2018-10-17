MODULE LinearMove
    ! This module handles the motion commands for linear jogging. 
    ! it moves the EndEffector in linear axis by small increments.
    ! Joseph Salim
    ! 170909
    
    VAR robtarget currPos;
    VAR num moveIncrement := 50;
    
    ! This function checks which linear direction the command sends
    PROC LinearJogRoutine(num JogDir)
        TEST JogDir
        CASE 1:
            MoveXPos;
        CASE 2:
            MoveXNeg;
        CASE 3:
            MoveYPos;
        CASE 4:
            MoveYNeg;
        CASE 5:
            MoveZPos;
        CASE 6:
            MoveZNeg;
        DEFAULT :
            TPWrite "Illegal choice";
        ENDTEST
    ENDPROC
    
    ! This function moves the robot linearly in the Z+ direction
    PROC MoveZPos()
        currPos := CRobT(\Tool:=tSCup \WObj:= wobj0);
        MoveL Offs(currPos, 0, 0, moveIncrement), robSpeed, finesse, tSCup;        
    ENDPROC
    
    ! This function moves the robot linearly in the Z- direction
    PROC MoveZNeg()
        currPos := CRobT(\Tool:=tSCup \WObj:= wobj0);      
        MoveL Offs(currPos, 0, 0, -moveIncrement), robSpeed, finesse, tSCup;
    ENDPROC
    
    ! This function moves the robot linearly in the Y+ direction
    PROC MoveYPos()
        currPos := CRobT(\Tool:=tSCup \WObj:= wobj0); 
        MoveL Offs(currPos, 0, moveIncrement, 0), robSpeed, finesse, tSCup;  
    ENDPROC
    
    ! This function moves the robot linearly in the Y- direction
    PROC MoveYNeg()
        currPos := CRobT(\Tool:=tSCup \WObj:= wobj0); 
        MoveL Offs(currPos, 0, -moveIncrement, 0), robSpeed, finesse, tSCup;   
    ENDPROC
    
    ! This function moves the robot linearly in the X+ direction
    PROC MoveXPos()
        currPos := CRobT(\Tool:=tSCup \WObj:= wobj0);
        MoveL Offs(currPos, moveIncrement, 0, 0), robSpeed, finesse, tSCup;  
    ENDPROC
    
    ! This function moves the robot linearly in the X- direction
    PROC MoveXNeg()
        currPos := CRobT(\Tool:=tSCup \WObj:= wobj0);
        MoveL Offs(currPos, -moveIncrement, 0, 0), robSpeed, finesse, tSCup;  
    ENDPROC
    
ENDMODULE