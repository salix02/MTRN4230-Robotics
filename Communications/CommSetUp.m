%% Communication port set ups
% socket = tcp obj if successful, else FALSE
% robot_IP_address = '192.168.125.1';
% robot_IP_address = '127.0.0.1';
% sets up and attempts to connect to Robot studio TCP server.
% Input Arguments:
% IpAdd: string Ip address of the server to connect to.
% Port: string of the port number of the socket to connect to.
% Joseph Salim
% 171115

function socket = CommSetUp(IpAdd, Port)
    socket = tcpip(IpAdd, Port);
    if(Port == 2015)
        set(socket, 'ReadAsyncMode', 'continuous');
    end
    fopen(socket);
    if(isequal(get(socket, 'Status'), 'open'))
        disp(['Comms Connected ', IpAdd, ' on port ', num2str(Port)]);
    else
        warning(['Could not open TCP connection to ', IpAdd, ' on port ', num2str(Port)]);
        socket = FALSE;
    end
end

