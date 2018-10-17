function coord2cell(result1)
%coord2cell
%   this function takes detection results from table frame
%   it converts local coordinates to cell numbers and global cell coordinates 
%   it provides essential info to interact with board GUI
%   all info is stored in global struct detection_State
global on_table not_inside_grid on_board on_deck1 on_deck2
global board_stat deck1_stat deck2_stat
global detection_State
    x_gap=54.5611;
    y_gap=54.9671;
    
    temp=find(result1(:,6)==1);
    on_table=result1(temp,:);
    on_table(:,3)=on_table(:,3)*-1;
    temp=find(on_table(:,7)==0);
    on_table(:,2)=1200-on_table(:,2);
    detection_State.on_table_TBframe=on_table;
    not_inside_grid=on_table(temp,1:5);
    not_inside_grid=table2global(not_inside_grid);
    
    temp=find(on_table(:,7)==1);
    on_board=on_table(temp,1:5);
    x=on_board(:,1); y=1200-on_board(:,2);
    for i=1:length(x)
        celly=ceil((x(i)-563)/x_gap);
        cellx=ceil((y(i)-284)/y_gap);
        if cellx==0, cellx=1; end;
        if cellx==10, cellx=9; end;
        if celly==0, celly=1; end;
        if celly==10, celly=9; end;
        board_stat(cellx,celly,1)=on_board(i,4);
        board_stat(cellx,celly,2)=on_board(i,5);
    end
    on_board=table2global(on_board);
    
    temp=find(on_table(:,7)==2);
    on_deck1=on_table(temp,1:5);
    y=1200-on_deck1(:,2);
    for i=1:length(y)
        cellx=ceil((y(i)-284)/y_gap);
        if cellx==0, cellx=1; end;
        if cellx==7, cellx=6; end;
        deck1_stat(cellx,1,1)=on_deck1(i,4);
        deck1_stat(cellx,1,2)=on_deck1(i,5);
    end
    on_deck1=table2global(on_deck1);
    
    temp=find(on_table(:,7)==3);
    on_deck2=on_table(temp,1:5);
    y=1200-on_deck2(:,2);
    for i=1:length(y)
        cellx=ceil((y(i)-284)/y_gap);
        if cellx==0, cellx=1; end;
        if cellx==7, cellx=6; end;
        deck2_stat(cellx,1,1)=on_deck2(i,4);
        deck2_stat(cellx,1,2)=on_deck2(i,5);
    end
    on_deck2=table2global(on_deck2);
    on_table=table2global(on_table);
    
    detection_State.on_table=on_table;
    detection_State.not_inside_cell=not_inside_grid;
    detection_State.deck1_coord=on_deck1;
    detection_State.deck2_coord=on_deck2;
    detection_State.board_coord=on_board;
    detection_State.deck1_matrix=deck1_stat;
    detection_State.deck2_matrix=deck2_stat;
    detection_State.board_matrix=board_stat;
end