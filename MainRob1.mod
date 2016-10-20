
MODULE MainRob1
    
PERS robtarget target_camera:=[[344,-32.9,672.92],[1.26585E-05,-0.00690216,-0.999976,2.18591E-05],[0,-1,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
CONST jointtarget target_home:=[[0,0,0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
PERS robtarget target_gripper:=[[350,-6,400],[0,-0.382683433,0.923879532,0],[-1,0,-1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];    


PERS robtarget rtarget_p0:=[[0,200,-50.3],[0.382683,0,0,-0.92388],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]; !punto origen
PERS robtarget rtarget_p1:=[[0,300,-39.2],[0.382683,0,0,-0.92388],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]; !punto destino
PERS robtarget rtarget_p2:=[[28,-219,170],[0,-0.382683433,0.923879532,0],[-1,0,-1,0],[9E9,9E9,9E9,9E9,9E9,9E9]]; !punto de descarga de piezas

PERS pos pos_p0:=[0,200,-50.3];
PERS pos pos_p1:=[0,300,-39.2];

! PERS num workpiece_height:=30;
CONST num safe_height:=110;
PERS num offset_height:=110;
PERS num dif_queen_rook := 2;

    PROC Main()
      
    !ConnectServer GetSysInfo(\LanIp),8005;
    !ConnectServer "192.168.1.103",8001;
    ConnectServer "127.0.0.1",8001;
    
    WHILE TRUE DO
          ReadCommand;
    ENDWHILE
       
    ENDPROC
  
    PROC UpdateTargets()
                
        rtarget_p0.trans := pos_p0;
        rtarget_p1.trans := pos_p1;
        
    ENDPROC
    
    PROC HomeCamera() 
        
        MoveJ target_camera,v500,z50,tool_camera\WObj:=wobj0;
      !  WaitTime(2);    
    ENDPROC
    
    PROC CenterTable() 
        
        MoveJ target_gripper,v300,z50,tool_gripper\WObj:=wobj0;
        !HomeGripper;
        
    ENDPROC
    
    
    PROC Home() 
        
        MoveAbsJ target_home\NoEOffs,v500,z50,tool0\WObj:=wobj0;
            
    ENDPROC
    
    PROC NormalMove()
        
       rtarget_p1.trans.z := rtarget_p0.trans.z;
       !abrir pinza
       !HomeGripper;
       !OpenGripper;
       MoveJ Offs(rtarget_p0,0,0,-safe_height),v500,fine,tool_gripper\WObj:=wobj_table;   ! Mover altura segura
       MoveL rtarget_p0,v50,fine,tool_gripper\WObj:=wobj_table; ! Mover de forma lineal a la pieza con un punto de paro
       GrippingPiece;                       ! agarrar pieza
       MoveL Offs(rtarget_p0,0,0,-offset_height),v50,fine,tool_gripper\WObj:=wobj_table; 
       
      
       MoveL Offs(rtarget_p1,0,0,-offset_height),v200,fine,tool_gripper\WObj:=wobj_table;
        
       MoveL Offs(rtarget_p1,0,0,-5),v50,fine,tool_gripper\WObj:=wobj_table; 
       
       
       DropPiece;   ! soltar pieza
       MoveL Offs(rtarget_p1,0,0,-safe_height),v50,z10,tool_gripper\WObj:=wobj_table;   ! Mover altutra segura
    
    ENDPROC
    
    PROC AttackMove()
      
       !abrir pinza
      ! HomeGripper;
      ! OpenGripper;
       MoveJ Offs(rtarget_p1,0,0,-safe_height),v500,fine,tool_gripper\WObj:=wobj_table;   ! Mover altura segura
       MoveL rtarget_p1,v50,fine,tool_gripper\WObj:=wobj_table; ! Mover de forma lineal a la pieza con un punto de paro
       GrippingPiece;                                           ! agarrar pieza
       MoveL Offs(rtarget_p1,0,0,-safe_height),v50,fine,tool_gripper\WObj:=wobj_table; 
       
        
       MoveJ rtarget_p2,v200,fine,tool_gripper\WObj:=wobj0; 

       DropPiece;   ! soltar pieza
      
       HomeGripper;
       OpenGripper;
       NormalMove;
       
    ENDPROC
    
     PROC ShortCastlingMove()
    
       
        dif_queen_rook := rtarget_p1.trans.z - rtarget_p0.trans.z;
        
        NormalMove;
        
        rtarget_p0 := Offs(rtarget_p0,150,0,dif_queen_rook);
        rtarget_p1 := Offs(rtarget_p1,-50,0,dif_queen_rook);
        offset_height := 120;
        HomeGripper;
        OpenGripper;
        NormalMove;
        
    ENDPROC
    
      PROC LongCastlingMove()
    
       
        dif_queen_rook := rtarget_p1.trans.z - rtarget_p0.trans.z;
        
        NormalMove;
        
        rtarget_p0 := Offs(rtarget_p0,-200,0,dif_queen_rook);
        rtarget_p1 := Offs(rtarget_p1,50,0,dif_queen_rook);
        offset_height := 120;
        
        HomeGripper;
        OpenGripper;
        NormalMove;
        
    ENDPROC
    
    
    PROC HumanWait()
        MoveJ rtarget_p2,v500,fine,tool_gripper\WObj:=wobj0; 
        HomeGripper;
        
       ! WaitDI DI10_6,1; !Esperar boton
   
    ENDPROC
   
    
    PROC HomeGripper()
        
        SetDO DO10_7,1;
        WaitDI DI10_5,1,\MaxTime:=200;
        SetDO DO10_7,0;
        
    ENDPROC
    
    PROC OpenGripper()
        
        SetDO DO10_8,1;
        WaitTime 3.5;
        SetDO DO10_8,0;
        
    ENDPROC
    
    PROC DropPiece()
        
        SetDO DO10_7,0;
        SetDO DO10_8,1;
        WaitTime 1.5;
        SetDO DO10_8,0;
        
    ENDPROC
    
    
    PROC GrippingPiece()
      
       SetDO DO10_7,1;
       WaitTime 3.0;
     !  SetDO \SDelay := 2, DO10_7,0;
       
    ENDPROC
    PROC CloseGripper()
        SetDO DO10_7,1;
        WaitTime 3.5;
        SetDO\SDelay:=2,DO10_7,0;
    ENDPROC
    
 

        

ENDMODULE