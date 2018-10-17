% Testing_Detection_Spoofer_app callback functions
% author: Sean Thompson
% Last modified: 10/11/2017

global p1;%[shape, color] temp for player selection
global detection_State;
global spoofer_app;
global spoofer_buttons;
global handleboard;

spoofer_app= Testing_Detection_Spoofer_app();
spoofer_app_init();

function spoofer_app_init()
    global spoofer_app spoofer_buttons;

    % setup the grid cell callbacks
    set(spoofer_app.board_grid_Panel.Children, 'ButtonPushedFcn', @spoofer_cell_callback);
    % deck callbacks
    spoofer_buttons.p1 = [spoofer_app.Button_p11, spoofer_app.Button_p12, spoofer_app.Button_p13, spoofer_app.Button_p14, spoofer_app.Button_p15, spoofer_app.Button_p16]; 
    set(spoofer_buttons.p1, 'ButtonPushedFcn', @spoofer_p1deck_callback);
    spoofer_buttons.p2 = [spoofer_app.Button_p21, spoofer_app.Button_p22, spoofer_app.Button_p23, spoofer_app.Button_p24, spoofer_app.Button_p25, spoofer_app.Button_p26]; 
    set(spoofer_buttons.p2, 'ButtonPushedFcn', @spoofer_p2deck_callback);

    set(spoofer_app.Button_Enable_Pattern, 'ButtonPushedFcn', @button_enable_pattern_callback);
    set(spoofer_app.Button_Clear_Detection, 'ButtonPushedFcn', @button_clear_detection_callback);
    set(spoofer_app.Button_Update_GUI, 'ButtonPushedFcn', @button_update_game_gui_callback);

    % make the board buttons addressable
    % need minimum 2 buttons to make array
    spoofer_buttons.grid = [spoofer_app.Button_11, spoofer_app.Button_12];
    for colInd=[3:9]
        spoofer_buttons.grid = [spoofer_buttons.grid, eval(sprintf('spoofer_app.Button_1%d', colInd))];
    end
    for rowInd = [2:9]
        grid_row = [eval(sprintf('spoofer_app.Button_%d1', rowInd)), eval(sprintf('spoofer_app.Button_%d2', rowInd))];
        %grid_row = eval(sprintf('[spoofer_app.Button_%d1, spoofer_app.Button_%d2]', rowInd));
        for colInd = [3:9]
            grid_row = [grid_row, eval(sprintf('spoofer_app.Button_%d%d', rowInd, colInd))];
        end
        spoofer_buttons.grid = [spoofer_buttons.grid; grid_row];
    end
    % DEBUG_VIS_spoofer_grid_addressing();

    disp('DEBUG: Spoofer app setup complete');
end

%% Debugging visualisation function, labels spoofer grid buttons with their indices
%   in the 2D spoofer_buttons.grid array, 
%   to confirm array indices match button layout
function DEBUG_VIS_spoofer_grid_addressing()
    global spoofer_buttons;
    for row = [1:9]
        for col = [1:9]
            spoofer_buttons.grid(row,col).Text = sprintf('r%dc%d', row, col);
        end
    end
end


function button_enable_pattern_callback(hObject, eventdata, handles)
    global handleboard;
    % rely on game GUI app is setup
    set(handleboard.pattern_select_Panel.Children, 'Enable', 'on');
end

function button_clear_detection_callback(hObject, eventdata, handles)
    global detection_State spoofer_buttons board_buttons;
    detection_State.board_matrix  = zeros(9,9,2);
    detection_State.deck1_matrix = zeros(6,1,2);
    detection_State.deck2_matrix = zeros(6,1,2);
    % clear the icons from the cleared block positions so GUI shows correct state
    set(spoofer_buttons.grid, 'Icon', '');
    set(spoofer_buttons.p1, 'Icon', '');
    set(spoofer_buttons.p2, 'Icon', '');
    % clear visual on game GUI as well
    set(board_buttons.grid, 'Icon', '');
    set(board_buttons.p1, 'Icon', '');
    set(board_buttons.p2, 'Icon', '');

end

function button_update_game_gui_callback(hObject, eventdata, handles)
    %update_from_detection();
end


function spoofer_p1deck_callback(hObject, eventdata, handles)
    global detection_State spoofer_app p1;
    deck_cell_ind = 1+(spoofer_app.Button_p11.Position(2) - eventdata.Source.Position(2))/59;
    fprintf('DEBUGGING: spoofer deck1 clbk cell:%d: p1=[%d,%d]\n', deck_cell_ind, p1(1), p1(2));
    % note detection_State.deck1_matrix(cell_ind, player, col=1_shp=2)
    % p1(shape,color)
    detection_State.deck1_matrix(deck_cell_ind, 1, 1) = p1(2);
    detection_State.deck1_matrix(deck_cell_ind, 1, 2) = p1(1);
    if (p1(1)~=0 && p1(2)~=0)
        hObject.Icon = pick(p1);
    else
        % clearing
        hObject.Icon = '';
    end
end

function spoofer_p2deck_callback(hObject, eventdata, handles)
    global detection_State spoofer_app p1;
    deck_cell_ind = 1+(spoofer_app.Button_p21.Position(2) - eventdata.Source.Position(2))/59;
    fprintf('DEBUGGING: spoofer deck2 clbk cell:%d: p1=[%d,%d]\n', deck_cell_ind, p1(1), p1(2));
    % note detection_State.deck1_matrix(cell_ind, player, col=1_shp=2)
    % p1(shape,color)
    detection_State.deck2_matrix(deck_cell_ind, 1, 1) = p1(2);
    detection_State.deck2_matrix(deck_cell_ind, 1, 2) = p1(1);
    if (p1(1)~=0 && p1(2)~=0)
        hObject.Icon = pick(p1);
    else
        % clearing
        hObject.Icon = '';
    end
end



%% board any cell callback function
% NOTE the board_stat coordinate callculation within this function is 
% dependent on the position of the buttons relative to Button_11 and their
% current size and spacing.
% If the buttons are resized or rearranged the current implementation 
% WILL BREAK and will need to be updated
function spoofer_cell_callback(hObject, eventdata, handles)
    global spoofer_app spoofer_buttons p1 detection_State;
    % find selected cell coordinates to set board_stat appropriately
    % dependent on positions of buttons relative to Button_11, and current
    % size and spacing
    % Buttons have width 60 and height 60 (with 1 pixel overlap)
    %   gives effective button size for calculation 59 (hence magic 59
    %    divisor in calculation below)
    colcoord = 1+(spoofer_app.Button_11.Position(1) - eventdata.Source.Position(1))/-59;
    rowcoord = 1+(spoofer_app.Button_11.Position(2) - eventdata.Source.Position(2))/59;

    % PATTERN SELECTOR TO BOARD
    %   DOES NOT TAKE BLOCK SELECTION FROM DECKS
    fprintf('DEBUGGING spoofer cell clbk: p1=[%d,%d]\n', p1(1), p1(2));
    spoofer_cell_update(rowcoord, colcoord, p1);
end


