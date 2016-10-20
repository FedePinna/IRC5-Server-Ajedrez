MODULE Server

VAR socketdev server_socket;
VAR socketdev client_socket;
VAR string receive_string;
VAR string send_string;
VAR string client_ip;
VAR num prueba:=100;
VAR pos rpos;

VAR num pos_chr0:=1;
VAR num pos_chr1:=1;
VAR num i:=1;
VAR string cmd{5};

PROC GetCommand(string msg)

    pos_chr1:=StrFind(msg,pos_chr1," ");

    WHILE pos_chr1<=(StrLen(msg)-1) DO

        cmd{i}:=StrPart(msg,pos_chr0,(pos_chr1-pos_chr0)); !Obtener cadena desde la ultima posicion leida hasta la nueva
        pos_chr1:=pos_chr1+1;                              !Incrementar el indice de caractere
        pos_chr0:=pos_chr1;                                !Guardar el indice de caractere
        i:=i+1;                                            !Incrementar el vector string
        pos_chr1:=StrFind(msg,pos_chr1," ");               !Buscar el caracter $ y guardar el indice donde se encuentra 

    ENDWHILE

    cmd{i}:=StrPart(msg,pos_chr0,(pos_chr1-pos_chr0));

    %cmd{1}%;
    
    FOR i FROM 1 TO 5 DO
        cmd{i}:="";
    ENDFOR

    i:=1;
    pos_chr1:=1;
    pos_chr0:=pos_chr1;
     
ENDPROC

PROC ConnectServer(string ip_string,num port)
    
    SocketCreate server_socket;
    SocketBind server_socket, ip_string,port;
    SocketListen server_socket;
    SocketAccept server_socket, client_socket \ClientAddress:=client_ip;

ENDPROC

PROC ReadCommand()

    SocketReceive client_socket \Str := receive_string;    
    
    GetCommand receive_string;
    
    SocketSend client_socket  \Str:=send_string+"\0A"; !"\0A"+
   
    
    
    ERROR
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            RETRY;
        ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
            RETURN;
        ELSE
            ! No error recovery handling
        ENDIF

ENDPROC

    

ENDMODULE