MODULE MoveTo
    ! This module has functions to move the robots to preset positions
    ! Joseph Salim
    ! 170909    
    
    PROC GoHome()
        MoveabsJ jtCalibPos, defaultSpeed, fine, tSCup;        
    ENDPROC
    
 PROC MoveTableHome()
     
     MoveJ pTableHome,defaultSpeed,fine,tSCup;
     
 ENDPROC
 
  PROC MoveConveyorHome()      
     MoveJ pConvHome,defaultSpeed,fine,tool0;
     
 ENDPROC
 
 PROC MoveConveyorBlock()
     MoveabsJ ConveyorPreBlock, defaultSpeed, fine, tSCup;
     MoveAbsJ ConveyorBlock, defaultSpeed, fine, tsCup;
 ENDPROC
     

 
ENDMODULE