%% Initialization code is written in the very beginning of each timing file
global GUI_ENABLE PLOT_ENABLE;
GUI_ENABLE = true;
PLOT_ENABLE = false;
idle(700)
Initialize_Trial(TrialRecord);
global Data RunData;

RunData.RFID.Count = 0; % i added this line
%% set task parameters

hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);'); % press 'x' twice to interrupt while loop; once if outside while loop
hotkey('t', 'goodmonkey(500);');
hotkey('z', 'Zero();');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% identify which animal is working

MM = {'090635077713','090635065204','090635065187','090635059034',}; % all animals 

while(RunData.RFID.Count == 0) % do nothing while no RFID
    [scancode, rt] = getkeypress(10);
    if scancode == 45
        eventmarker(17);
        break % press 'x' twice to interrupt
    end
end

M = cell2mat(RunData.RFID.Data(end).ID);
for i=1:length(MM)
    if strcmp(M,cell2mat(MM(i))) == 1
        eventmarker(100+i);
    end
end
G1 = {'090635077713'}; % 
G2 = {'090635065204'}; % 
G3 = {'090635065187'}; % 
G4 = {'090635059034'}; % 

RunData.RFID.Data(end).ID

if size(TrialRecord.User,1)<30 || length(unique(TrialRecord.User(end-29:end,1)))>1 || (length(unique(TrialRecord.User(end-29:end,1)))==1 && strcmp(TrialRecord.User(end,1),M)==0)
    
    
    bhv_code(10,'Hold Cue',20,'Choice',30,'Hold',90,'Reward',96, 'Distractor', 3, 'No touch Hold', 4,...
        'Touch Break Hold', 23, 'No Touch Choice', 33, 'No Touch Target', 34, 'Touch Break Target');  % behavioral codes
    
    editable('NumReward','wait_for_touch','max_reaction_time','hold_target_time','hold_radius', 'X_1', 'Y_1', 'X_FP', 'Y_FP', 'X_Stim', 'Y_Stim','Reframe');
    
%     Hold_cue=10;
%     Choice=20;
%     Hold=30;
%     Reward=90;
%     Distractor=96;
%     No_touch_hold=13;
%     Touch_Break_hold=14;
%     No_Touch_Choice=23;
%     No_Touch_Target=33;
%     Touch_Break_Target=34;
%     
    
    %     if ismember(M,[G1 G4]) == 1 % indicate the level at which each mk starts
    %         % give names to the TaskObjects defined in the conditions file:
    %         % ---- reversal
    %         touch_point = 1;
    %         target = 3;
    %         distractor = 2;
    %     elseif ismember(M,[G2 G3 G5]) == 1
    %         % give names to the TaskObjects defined in the conditions file:
    %         % ---- orig
    %         touch_point = 1;
    %         target = 2;
    %         distractor = 3;
    %     end
    
    % event codes
    RF_ID_read=17;
    NO_RFID=19;
    MID=[101 102 103 104];
    touch_point_ON=20;
    touch_point_OFF=21;
    FP_ON =22;
    FP_OFF=23;
    STIM_ON= 24;
    STIM_OFF=25;
    Targets_ON=26;
    Targets_OFF=27;
    Reward=90;

    % give names to the TaskObjects defined in the conditions file:
    touch_point = 1;
    fixation_point=2;
    Stim = 5;
    T1= 3;%right
    T2= 4;%left
    
    
    % define time intervals (in ms):
    
    
    wait_for_touch = 100;
    max_reaction_time = 5000;
    hold_target_time = 100;
    delay_fp=1000;
    % touch window (in degrees):
    touch_radius = 9; %6.07;
    hold_radius = 10.5; %9;
    NumReward = 2;
    X_1=0;
    Y_1=0;
    X_FP=0;
    Y_FP=0;
    X_Stim=0;
    Y_Stim=0;
    Reframe=0.5;
%     bgcolor=[0.45 0.45 0.45];
    
    success=reposition_object(1, [X_1 Y_1]);
    success=reposition_object(fixation_point, [X_FP Y_FP]);
    success=reposition_object(Stim, [X_Stim Y_Stim]);
    
    rescale_object(Stim, Reframe);
%     rescale_object(1, Reframe);
    
%     set_bgcolor(bgcolor);
    % proceed only when the screen is not being touched
%     toggleobject(1)
    toggleobject([touch_point], 'eventmarker',touch_point_ON);  % turn on touch point
    [ontarget,rt] = eyejoytrack('touchtarget',touch_point,touch_radius, '~touchtarget',touch_point,touch_radius, wait_for_touch);  % touching outside the window will abort the trial

    
    if ~ontarget(1)
        toggleobject([touch_point], 'eventmarker',touch_point_OFF);  % turn off touch point
        trialerror(3);  % broke fixation
        return
    end
    
    
    toggleobject([touch_point fixation_point], 'eventmarker',[touch_point_OFF FP_ON]);  % turn on fixation point turn off touch point
    %% does not seem to be working
%     toggleobject(fixation_point, 'eventmarker',FP_ON);  % turn on fixation point
    
    [ontarget,rt] = eyejoytrack('touchtarget',fixation_point,touch_radius, delay_fp);  % touching outside the window will abort the trial
%     if ontarget(1)
%         toggleobject(fixation_point, 'eventmarker',FP_OFF);  % turn off touch point
%         trialerror(4);  % touch fixation point
%         return
%     end
    
    toggleobject([fixation_point Stim], 'eventmarker',[FP_OFF STIM_ON]);  % turn off fixation point turn on stim
    %%
    
%     toggleobject(Stim, 'eventmarker', STIM_ON);  % turn on stimulus
%     toggleobject(, 'eventmarker',Targets_ON);  % turn on targets
    
    chosen_target = eyejoytrack('touchtarget', Stim, hold_radius, '~touchtarget',Stim,touch_radius,  Info.soa);
    if ontarget(1)
        toggleobject(Stim, 'eventmarker',STIM_OFF);  % turn off touch point
        trialerror(4);  % touch fixation point
        return
    end
    
    
    
    toggleobject([T1 T2], 'eventmarker', Targets_ON);  % turn on stimulus
    
    chosen_target = eyejoytrack('touchtarget', [T1 T2], hold_radius, max_reaction_time);
    
%     disp(chosen_target)
    
    if chosen_target==0
        toggleobject([Stim T1 T2], 'eventmarker',[STIM_OFF Targets_OFF]);
        trialerror(2);  % late response (did not land on either the target or distractor)
        return
    elseif chosen_target==Info.side
        toggleobject([Stim T1 T2], 'eventmarker',[STIM_OFF Targets_OFF]);
        trialerror(0); % correct
        goodmonkey(1000, 'NumReward',NumReward, 'eventmarker',Reward)
    elseif chosen_target~=Info.side
        toggleobject([Stim T1 T2], 'eventmarker',[STIM_OFF Targets_OFF]);
        trialerror(6); % correct
    end
else
    eventmarker(NO_RFID);
end

%% Record M and end trial
% idle(200) % to get the end of the movie
TrialRecord.User{TrialRecord.CurrentTrialNumber,1}= M;
End_Trial(); % Termination code is written in the very end of each timing file