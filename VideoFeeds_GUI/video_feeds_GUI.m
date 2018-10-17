function varargout = video_feeds_GUI(varargin)
% VIDEO_FEEDS_GUI MATLAB code for video_feeds_GUI.fig
%      VIDEO_FEEDS_GUI, by itself, creates a new VIDEO_FEEDS_GUI or raises the existing
%      singleton*.
%
%      H = VIDEO_FEEDS_GUI returns the handle to a new VIDEO_FEEDS_GUI or the handle to
%      the existing singleton*.
%
%      VIDEO_FEEDS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEO_FEEDS_GUI.M with the given input arguments.
%
%      VIDEO_FEEDS_GUI('Property','Value',...) creates a new VIDEO_FEEDS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before video_feeds_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to video_feeds_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help video_feeds_GUI

% Last Modified by GUIDE v2.5 24-Oct-2017 13:43:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @video_feeds_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @video_feeds_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before video_feeds_GUI is made visible.
function video_feeds_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to video_feeds_GUI (see VARARGIN)

% Choose default command line output for video_feeds_GUI
handles.output = hObject;

% video feed setup

%placeholder image setup
axes(handles.TableFeedAxes);
imshow('table_eg.jpg');

axes(handles.ConvFeedAxes);
imshow('conveyor_eg.jpg');


% adding app specific data fields

% named state values for convenience
handles.action_states.no_click = 1;
handles.action_states.first_click_table = 2;
handles.action_states.first_click_conv = 3;
handles.action_states.second_click_table_table = 4;
handles.action_states.second_click_table_conv = 5;
handles.action_states.second_click_conv_conv = 6;
handles.action_states.second_click_conv_table = 7;

% initially no click action started
handles.user_action_state = handles.action_states.no_click;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes video_feeds_GUI wait for user response (see UIRESUME)
% uiwait(handles.VideoFeedsAppFig);
end

% --- Outputs from this function are returned to the command line.
function varargout = video_feeds_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on mouse press over axes background.
function TableFeedAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TableFeedAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('DEBUGGING: TableFeedsAxes Clicked');
DebuggingPrevStatus(handles);
if handles.user_action_state == handles.action_states.no_click
    handles.user_action_state = handles.action_states.first_click_table;
elseif handles.user_action_state == handles.action_states.first_click_table
    % table -> table
    handles.user_action_state = handles.action_states.second_click_table_table; 
elseif handles.user_action_state == handles.action_states.first_click_conv
    % click conv -> table
    handles.user_action_state = handles.action_states.second_click_conv_table; 
end

DebuggingCurrentStatus(handles);
fprintf('----------------------------\n');

ProcessAction(hObject, handles);

% Update handles structure
guidata(hObject, handles);
end


% --- Executes on mouse press over axes background.
function ConvFeedAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ConvFeedAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('DEBUGGING: ConvFeedAxes Clicked');
DebuggingPrevStatus(handles);
if handles.user_action_state == handles.action_states.no_click
    handles.user_action_state = handles.action_states.first_click_conv;
elseif handles.user_action_state == handles.action_states.first_click_conv
    % click conv -> conv
    handles.user_action_state = handles.action_states.second_click_conv_conv;
elseif handles.user_action_state == handles.action_states.first_click_table
    % table -> conv
    handles.user_action_state = handles.action_states.second_click_table_conv;   
end

DebuggingCurrentStatus(handles);
fprintf('----------------------------\n');

ProcessAction(hObject, handles);

% Update handles structure
guidata(hObject, handles);
end

function ProcessAction(hObject, handles)
% return early if only 1st click, action to process has not yet been chosen
if any(handles.user_action_state == [handles.action_states.no_click, handles.action_states.first_click_conv, handles.action_states.first_click_table])
% no work to do
else
    % call other processing based on selected move

    % reset state for next action
    handles.user_action_state = handles.action_states.no_click;    
end
% Update handles structure
guidata(hObject, handles);
end

% --- Outputs debugging information about the state of the app
function DebuggingStatus(handles)
% handles    structure with handles and user data (see GUIDATA) passed by
%               calling functions
fprintf('action_state: ');
if handles.user_action_state == handles.action_states.no_click
    fprintf('no_click: waiting for  1st click');
elseif handles.user_action_state == handles.action_states.first_click_table
    fprintf('1st click table: waiting 2nd click');
elseif handles.user_action_state == handles.action_states.first_click_conv
    fprintf('1st click conveyor: waiting 2nd click');        
elseif handles.user_action_state == handles.action_states.second_click_table_table
    fprintf('2nd click: table -> table');    
elseif handles.user_action_state == handles.action_states.second_click_table_conv
    fprintf('2nd click: table -> conv');    
elseif handles.user_action_state == handles.action_states.second_click_conv_table    
    fprintf('2nd click: conv -> table');
elseif handles.user_action_state == handles.action_states.second_click_conv_conv
    fprintf('2nd click: conv -> conv');   
else
    fprintf('ERROR: handles.user_action_state unknown value');
end
fprintf('\n');
end

function DebuggingPrevStatus(handles)
fprintf('prev ');
DebuggingStatus(handles);
end

function DebuggingCurrentStatus(handles)
fprintf('current ');
DebuggingStatus(handles);
end

