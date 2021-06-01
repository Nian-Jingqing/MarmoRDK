%% General experimenter launcher
%  =============================
% By :      Martin SZINTE
% Projet :  MarmStim
% With :    Guillaume MASSON & Guilhem IBOS

% Version description
% ===================
% Generate design file and video stimuli to use in monkey logic
% make demo on psychtoolbox and video
% Design : . 10 blocks with different noise duration between 50 and 500 ms
%          . stim = rdk with direction coherence moving left or right at different kappa level

% Trial timecourse :    . A circle until monkey touch on touchscreen (demo = press space)
%                       . reward for touch with fixation mark on stim center
%                       . noise stimulus (random of rdk 75 to 500 ms between blocks)
%                       . signal stimulus (right or left ~800 ms coherent rdk at 5 possible level of orientation dispersion)
%                       . two button until responsew with 1 second max to touch screen (demo left and right button)
%                       . if correct response reward with water
 
% vid/img to create :   . touch button (img)   
%                       . reward button (img)
%                       . noise (50 to 500 ms video)
%                       . signal (300 ms video, with left or right and 5 level of difficulty)
%                       . two button response (img)

% To do
% -----
% adapt it with monkeylogic
%       . check how to upload design
%       . check how to incorporate images and videos
%       . check how to create touch screen interaction
%       . check screen settings

% First settings
% --------------
Screen('CloseAll');clear all;clear mex;clear functions;close all;home;AssertOpenGL;

% General settings
% ----------------
const.expName           =   'MarmoRDK';     % experiment name
const.debug             =   1;              % Debug mode                                0 = YES , 1 = NO
const.mkVideo           =   0;              % Make a video of a run                     0 = NO  , 1 = YES
const.ml_material       =   1;              % Save images and videos for monleylogic    0 = NO  , 1 = YES
if const.ml_material;const.mkVideo=0;end

% Path
% ----
dir                     =   (which('expLauncher'));
cd(dir(1:end-18));

% Add Matlab path
% ---------------
addpath('config','main','conversion','trials','stim','ml');

% Main run
% --------
main(const);
