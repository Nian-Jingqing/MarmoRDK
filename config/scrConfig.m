function [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define configuration relative to the screen
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing screen configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 05 / 2021
% Project :     MarmStim
% Version :     3.0
% ----------------------------------------------------------------------

% Number of the exp screen :
scr.all                 =   Screen('Screens');
scr.scr_num             =   max(scr.all);

% Screen resolution (pixel) :
scr.scr_sizeX           =   480;    % ~ 73 dva
scr.scr_sizeY           =   800;    % ~ 122 dva (only 1/2 top usable ~61 dva)
scr.rect                =   [0,0,480,800];
scr.vid_sizeX           =   480;
scr.vid_sizeY           =   800;

% Settings Noritake screen
scr.disp_sizeX          =   85.92;
scr.disp_sizeY          =   154.08;
scr.dist                =   3;

% Pixels size :
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame rate : (fps)
scr.frame_duration      =   1/(Screen('FrameRate',scr.scr_num));
if scr.frame_duration == Inf
    scr.frame_duration = 1/60;
end

% Frame rate : (hertz)
scr.hz                  =   1/(scr.frame_duration);

if const.debug == 1
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference','SyncTestSettings', 0.01, 50, 0.25);
elseif const.debug == 0
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference','SyncTestSettings', 0.01, 50, 0.25);
    Screen('Preference','SuppressAllWarnings', 1);
    Screen('Preference','Verbosity', 0);
end

% Center of the screen :
scr.x_mid               =   (scr.scr_sizeX/2.0);
scr.y_mid               =   (scr.scr_sizeY/2.0);
scr.mid                 =   [scr.x_mid,scr.y_mid];

end