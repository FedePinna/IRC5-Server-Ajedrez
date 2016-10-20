MODULE Commands

VAR pos type_pos;
VAR num type_num;
VAR bool res_conver;


PROC wrdata()  
     
    TEST cmd{2}
    
    CASE "pos":    
        res_conver:=StrToVal(cmd{4},type_pos);
        SetDataVal cmd{3},type_pos;
    CASE "num":
        res_conver:=StrToVal(cmd{4},type_num);
        SetDataVal cmd{3},type_num;

    DEFAULT:

    ENDTEST
    
    send_string:="ok";

ENDPROC

PROC rutine()
   
    %cmd{2}%;
    
    send_string:="finish";
    
ENDPROC

PROC closesocket()

    SocketClose server_socket;
    SocketClose client_socket;
    
ENDPROC
    

PROC rdata()
    
    TEST cmd{2}

    CASE "pos":
        GetDataVal cmd{3},type_pos;
        cmd{1}:=cmd{2};      
        cmd{2}:= ValToStr(type_pos);
    CASE "num":
        GetDataVal cmd{3},type_num;
        cmd{1}:=cmd{2};      
        cmd{2}:= ValToStr(type_num);
    DEFAULT:

    ENDTEST
    
    send_string:=cmd{1}+cmd{2};
    
ENDPROC


ENDMODULE
