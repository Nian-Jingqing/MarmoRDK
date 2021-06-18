%% Initial settings
global GUI_ENABLE PLOT_ENABLE;
GUI_ENABLE = true;
PLOT_ENABLE = false;

%% Required Initialization Sequence for the Marmoset Smart Chair
idle(500)
global RunData Data;
target1 = false;
Initialize_Trial(TrialRecord);
showcursor('off');

%% Load values
matfile = load('F:/Experiments/MarmoRDK/ml/MarmoRDK.mat');
const = matfile.config.const;

%% Define buttons and trial number
hotkey('t', 'goodmonkey(1000);'); % press key t on keyboard to give one reward 
hotkey('z', 'Zero();'); % press key z on keyboard to zero the weight manually
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');

if 1 < TrialRecord.CurrentTrialNumber % Make the eventmarkers from the previous trials accessible online
    TrialRecord.User.TrialCodes(TrialRecord.CurrentTrialNumber-1) = TrialRecord.LastTrialCodes;
end



%% Sample image presented
% Trial start
eventmarker(const.start_trigger);

% T1: button to touch
toggleobject([const.movie_t3_obj],'EventMarker', const.t3_triggerfff);
%toggleobject([const.button_t1_obj,const.movie_t1_obj],'EventMarker', const.t1_trigger);
%[t1_touch,~] = eyejoytrack('touchtarget', const.button_t1_obj, const.button_out_rim_radVal, const.button_t1_tmax);
pause(1)
t1_touch=1;

if t1_touch == 1
%     % T2: fixation and reward 1
%     goodmonkey(const.reward2_dur, 'NonBlocking', const.reward_nonblocking);
%     toggleobject([const.button_t1_obj, const.movie_t1_obj, const.movie_t2_obj],'EventMarker', const.t2_trigger);
%     pause(const.reward1_dur/1000);
    
    % T3: movie
    toggleobject([const.movie_t3_obj],'EventMarker', const.t3_trigger);
%     pause(2);
%     
%     % T4: response buttons
%     toggleobject([const.movie_t2_obj, const.movie_t3_obj, const.button_cor_t4_obj, const.button_inc_t4_obj, const.movie_t4_obj],...
%         'EventMarker', const.t4_trigger);
%     [t4_touch,~] = eyejoytrack('touchtarget', [const.button_cor_t4_obj, const.button_inc_t4_obj],...
%         const.button_touch_rad, const.button_t4_tmax);
%     
%     % T5: reward and/or iti
%     toggleobject([const.button_cor_t4_obj, const.button_inc_t4_obj, const.movie_t4_obj, const.movie_t5_obj],...
%                 'EventMarker', const.t5_trigger);
%     switch t4_touch
%         case 1
%             % correct response
%             eventmarker(const.cor_trigger);
%             trialerror(const.cor_code);
%             goodmonkey(const.reward2_dur, 'NonBlocking', const.reward_nonblocking);
%             pause(const.reward2_dur/1000);
%         case 2
%             % inccorrect response
%             eventmarker(const.inc_trigger);
%             trialerror(const.inc_code);
%             pause(const.reward2_dur/1000);
%         case 0
%             % no reponse
%             eventmarker(const.noresp_trigger);
%             trialerror(const.no_resp_code);
%             pause(const.reward2_dur/1000);
%     end
    
elseif t1_touch == 0 
    toggleobject([const.button_t1_obj,const.movie_t1_obj, const.movie_t5_obj],...
                'EventMarker', const.notouch_trigger);
    trialerror(const.ignored_code); % Sample image ignored
    pause(const.no_touch_iti);
end

% Trial end
eventmarker(const.end_trigger);    % End trial
End_Trial();
