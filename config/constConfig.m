function [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 05 / 2021
% Project :     MarmStim
% Version :     3.0
% ----------------------------------------------------------------------

% Randomization
rng('default');
rng('shuffle');

%% Screen settings (color, frame duration)
const.white             =   [255,255,255];          % white color
const.black             =   [0,0,0];                % black color
const.gray              =   [128,128,128];          % gray color
const.red               =   [200,0,0];              % red
const.green             =   [0,150,0];              % green
const.background_color  =   const.gray;             % background color
const.stim_color        =   const.white;            % stimulus color
const.ann_color         =   const.stim_color;       % define anulus around fixation color
const.ann_probe_color   =   const.stim_color;       % define anulus around fixation color when probe
const.dot_color         =   const.stim_color;       % define fixation dot color
const.dot_probe_color   =   const.black;            % define fixation dot color when probe

%% Time parameters
% Trial timing (in frames)
const.signal_soa_nbf_min=   5;                                              % minimum signal soa (in frames)
const.signal_soa_nbf_max=   33;                                             % maximum signal soa (in frames)
const.signal_soa_num    =   5;                                              % number of interal between 1 frame and 500 ms of soa

const.signal_soa_nbf    =   linspace(const.signal_soa_nbf_min,...
                                     const.signal_soa_nbf_max,...
                                     const.signal_soa_num);                 % signal onset time relative to rdk start (in frames)

const.signal_soa_dur    =   const.signal_soa_nbf*scr.frame_duration;        % signal onset time relative to rdk start (in seconds)
const.signal_nbf        =   53;                                             % signal duration (in frames)
const.signal_dur        =   const.signal_nbf*scr.frame_duration;            % signal duration (in seconds)
const.resp_dur          =   1;                                              % response duration (in seconds)
const.resp_nbf          =   66;                                             % response duration (in frames)

const.reward1_dur       =   1;                                              % reward #1 duration (in seconds)
const.reward1_nbf       =   round(const.reward1_dur/scr.frame_duration);    % reward #1 duration (in frames)
const.reward2_dur       =   1;                                              % reward #2 duration (in seconds)
const.reward2_nbf       =   round(const.reward2_dur/scr.frame_duration);    % reward #2 duration (in frames)

%% Stim parameters

% pixel per degrees
const.ppd               =   vaDeg2pix(1,scr);                               % get one pixel per degree

% fix dot
const.fix_out_rim_radVal=   5.0;                                            % radius of outer circle of fixation bull's eye
const.fix_rim_radVal    =   0.75*const.fix_out_rim_radVal;                  % radius of intermediate circle of fixation bull's eye in degree
const.fix_radVal        =   0.25*const.fix_out_rim_radVal;                  % radius of inner circle of fixation bull's eye in degrees
const.fix_out_rim_rad   =   vaDeg2pix(const.fix_out_rim_radVal,scr);        % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad       =   vaDeg2pix(const.fix_rim_radVal,scr);            % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad           =   vaDeg2pix(const.fix_radVal,scr);                % radius of inner circle of fixation bull's eye in pixels

% rdk
const.example_num       =   1;%10;                                             % number of random example of same motion
const.stim_ctr_XVal     =   0;                                              % stim center X position relative screen center (dva)
const.stim_ctr_YVal     =   80;                                             % stim center Y position relative screen center (dva)
const.stim_ctr_X        =   vaDeg2pix(const.stim_ctr_XVal,scr);             % stim center X position relative screen center (pixels)
[~,const.stim_ctr_Y]    =   vaDeg2pix(const.stim_ctr_YVal,scr);             % stim center Y position relative screen center (pixels)
const.stim_coords       =   [scr.x_mid-const.stim_ctr_X,...
                             scr.y_mid-const.stim_ctr_Y];                   % stimulus coordinates
const.rdk_rad           =   vaDeg2pix(50,scr);                              % item radius
const.dotRadSize        =   vaDeg2pix(2,scr);                               % dot size
const.theta_noise       =   90;                                             % noise direction (0:right, 90:up, 180:left, 270:down)
const.kappa_noise       =   0;                                              % noise motion coherence kappa
const.kappa_levels      =   5;                                              % kappa levels
const.kappa_scale       =   linspace(0,10,const.kappa_levels);              % kappa values

const.numDots           =   50;                                             % number of dots
const.dotSpeed_pix      =   vaDeg2pix(50,scr);                              % speed in degree per seconds                    
const.sigDotSpeedMulti  =   1;                                              % speed multiplication factor
const.numMinLife        =   3;                                              % minimum life time of a dot (in frames)
const.durMinLife        =   const.numMinLife*scr.frame_duration;            % minimum life time of a dot (in seconds)
const.numMeanLife       =   7;                                              % mean life time of a dot (in frames)
const.durMeanLife       =   const.numMeanLife*scr.frame_duration;           % mean life time of a dot (in seconds)

for signal_direction = 1:2
    switch signal_direction
        case 1; stim.theta_signal = 0;
        case 2; stim.theta_signal = 180;
    end
    
    for signal_soa = 1:const.signal_soa_num
        stim.durBef_nbf = const.signal_soa_nbf(signal_soa);
        stim.durAft_nbf = const.signal_nbf;
        
        for signal_kappa = 1:const.kappa_levels
            stim.kappa_signal = const.kappa_scale(signal_kappa);
            for signal_example = 1:const.example_num
                const.rdk{signal_direction,signal_soa,signal_kappa,signal_example} =...
                    compute_rdk(scr,const,stim);
            end
        end
    end
end

% buttons
const.button_distVal    =   40;                                             % button distance from center
const.button_dist       =   vaDeg2pix(const.button_distVal,scr);            % in pixels
                        
const.button_out_rim_radVal ...
                        =   20.0;                                           % radius of outer circle of touchbutton
const.button_out_rim_rad=   vaDeg2pix(const.button_out_rim_radVal,scr);     % in pixels

const.button_rim_rad    =   const.button_out_rim_rad - ...
                            (const.fix_out_rim_rad - const.fix_rim_rad);    % as a function of rim in fix bull's eye

const.button_color      =   const.green;                                    % button color
const.button_ctr_XVal   =   0;                                              % stim center X position relative screen center (dva)
const.button_ctr_YVal   =   0;                                              % stim center Y position relative screen center (dva)
const.button_ctr_X      =   vaDeg2pix(const.button_ctr_XVal,scr);             % stim center X position relative screen center (pixels)
[~,const.button_ctr_Y]  =   vaDeg2pix(const.button_ctr_YVal,scr);             % stim center Y position relative screen center (pixels)
const.button_coords     =   [scr.x_mid-const.button_ctr_X,...
                             scr.y_mid-const.button_ctr_Y];                 % stimulus coordinates

end
