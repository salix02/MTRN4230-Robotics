MODULE PickUpDownBlock
    !This module has functions with movement sequence to pick up and drop blocks.
    !It activates/deactivates the vacuum as well when end-effector is positioned correctly
    !Joseph Salim
    !171115
    
    PROC Temp()
        PickBlock 0, 407, 157, [0, 0, -1, 0];    ENDPROC
    
    ! This Process picks a block up from the position defined by the input arguments 
    ! X, Y and Z with orientation defined by the quaternion 'Quat'
    PROC PickBlock(num X, num Y, num Z, orient Quat)    
        VAR robtarget AboveBlock;
        VAR robtarget OnBlock;
        AboveBlock := pTableHome;
        OnBlock := pTableHome;

        AboveBlock.trans := [X, Y, 170];
        AboveBlock.rot := Quat;
        OnBlock.trans := [X, Y, Z];
        OnBlock.rot := Quat;

        MoveJ AboveBlock, defaultSpeed, fine, tSCup;
        MoveJ OnBlock, defaultSpeed, fine, tSCup;         

        WaitTime 0.5;
        TurnVacOn;
        WaitTime 0.5;

        MoveJ AboveBlock, defaultSpeed, fine, tSCup;
         
    ENDPROC

    ! This Process picks a block up from the position defined by the input arguments 
    ! X, Y and Z with orientation defined by the quaternion 'Quat'
    PROC DropBlock(num X, num Y, num Z, orient Quat)    
        VAR robtarget AboveBlock;
        VAR robtarget OnBlock;
        AboveBlock := pTableHome;
        OnBlock := pTableHome;

        AboveBlock.trans := [X, Y, 170];
        AboveBlock.rot := Quat;
        OnBlock.trans := [X, Y, Z];
        OnBlock.rot := Quat;

        MoveJ AboveBlock, defaultSpeed, fine, tSCup;
        MoveJ OnBlock, defaultSpeed, fine, tSCup;         
        
        WaitTime 0.5;
        TurnVacOff;
        WaitTime 0.5;
        MoveJ AboveBlock, defaultSpeed, fine, tSCup;
         
    ENDPROC
    
    ! This function turns the vacuum system on and suction on sequentially
    PROC TurnVacOn()
        
        ! Set Vacuum system on.
        SetDO DO10_1, 1;
        
        ! Set suction on
        SetDO DO10_2, 1;
        
    ENDPROC
    
    ! This function sets output 1/Vac to 0
    PROC TurnVacOff()
        
        ! Set suction off
        SetDO DO10_2, 0;
        ! Set Vacuum system off.
        SetDO DO10_1, 0;
    ENDPROC
    

        
ENDMODULE