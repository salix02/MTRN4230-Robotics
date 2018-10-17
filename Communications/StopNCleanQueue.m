%% stops robot movements and empties out movement queue in robot studio
% Joseph Salim
% 171115

function StopNCleanQueue()
    global MvSocket;
    
    fwrite(MvSocket,'8');
    fwrite(MvSocket,'6_0');
    waitWhileBusy;
    fwrite(MvSocket,'4_2_0');
    fwrite(MvSocket,'4_1_0');
     
    pause(0.15);
end