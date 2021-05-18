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

if size(TrialRecord.User,1)<30 || length(unique(TrialRecord.User(end-29:end,1)))>1 || (length(unique(TrialRecord.User(end-29:end,1)))==1 && strcmp(TrialRecord.User(end,1),M)==0)
    
    
    bhv_code(10,'Hold Cue',20,'Choice',30,'Hold',90,'Reward',96, 'Distractor', 3, 'No touch Hold', 4,...
        'Touch Break Hold', 23, 'No Touch Choice', 33, 'No Touch Target', 34, 'Touch Break Target');  % behavioral codes
    editable('NumReward','wait_for_touch','initial_touch','max_reaction_time','hold_target_time','hold_radius');
    
    Hold_cue=10;
    Choice=20;
    Hold=30;
    Reward=90;
    Distractor=96;
    No_touch_hold=13;
    Touch_Break_hold=14;
    No_Touch_Choice=23;
    No_Touch_Target=33;
    Touch_Break_Target=34;
    
    
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
    
    % give names to the TaskObjects defined in the conditions file:
    touch_point = 1;
    target = 2;
    distractor = 3;
    
    % define time intervals (in ms):
    wait_for_touch = 5000;
    initial_touch = 200;
    max_reaction_time = 2000;
    hold_target_time = 100;
    
    % touch window (in degrees):
    touch_radius = 9; %6.07;
    hold_radius = 10.5; %9;
    NumReward = 2;
    
    
    % scene 1: Hold
    touch1 = SingleTarget(touch_);     % We use touch signals (touch_) for tracking. The SingleTarget adapter
    touch1.Target = touch_point;  % checks if the touch is in the Threshold window around the Target.
    touch1.Threshold = touch_radius;   % The Target can be either TaskObject# or [x y] (in degrees).
    wth1 = WaitThenHold(touch1);          % The WaitThenHold adapter waits for WaitTime until the touch
    wth1.WaitTime = wait_for_touch;       % is acquired and then checks if the touch is held for HoldTime.
    wth1.HoldTime = initial_touch;        % Since WaitThenHold gets the touch status from SingleTarget,
    % SingleTarget (touch1) must be the input argument of WaitThenHold (wth1).
    scene1 = create_scene(wth1,touch_point);  % In this scene, we will present the touch_point (TaskObject #1)
    % and detect the touch indicated by the above parameters.
    
    % scene 2: choice
    mul2 = MultiTarget(touch_);           % The MultiTarget adapter checks fixation acquisition for multiple targets.
    mul2.Target = [target distractor];  % Target can be coordinates, like [x1 y1; x2 y2; x3 y3; ...], instead of TaskObject #.
    mul2.Threshold = hold_radius;
    mul2.WaitTime = max_reaction_time;
    mul2.HoldTime = 0;
    scene2 = create_scene(mul2,[target distractor]);
    
    mul3= SingleTarget(touch_);
    mul3.Target=target;
    mul3.Threshold=hold_radius;
    wth3 = WaitThenHold(mul3);
    wth3.WaitTime = 0;
    wth3.HoldTime = hold_target_time;
    scene3= create_scene(wth3, [target]);
%%
    % TASK:
    run_scene(scene1,Hold_cue);     % Run the first scene (eventmaker 10)
    % rt = wth1.AcquiredTime;   % For the reaction time graph
    if ~wth1.Success          % If the WithThenHold failed, (either fixation is not acquired or broken during hold)
        idle(0);              % Clear the screen
        if wth1.Waiting       % Check if we were waiting for touch.
            eventmarker (No_touch_hold)    % no touch error (eventmarker 13) during Hold stimulus presentation
            trialerror(1);    % If so, touch was never made and this is the "no touch (1)" error.
        else
            eventmarker (Touch_Break_hold)    % touche break error (eventmarker 14) during Hold stimulus presentation
            trialerror(2);    % If we were not waiting, it means that touch was acquired but not held,
        end %     so it is the "break touch (2)" error.
        idle(200) % to get the end of the movie
        TrialRecord.User{TrialRecord.CurrentTrialNumber,1}= M;
        End_Trial(); % Termination code is written in the very end of each timing file
        return
    end
    eventmarker(11) %Zhat is this even marker Hold success?
%%
    run_scene(scene2,Choice);     % Run the second scene (eventmarker 20) = choice
    if ~mul2.Success          % The failure of MultiTarget means that none of the targets was chosen.
        idle(0);              % Clear the screen.
        eventmarker (No_Touch_Choice); % no touch error in scene 2 = choice (eventmarker 23)
        trialerror(8);    % land on nothing, it is the "late response (8)" error.
        TrialRecord.User{TrialRecord.CurrentTrialNumber,1}= M;
        End_Trial(); % Termination code is written in the very end of each timing file
        return
    end
    if mul2.ChosenTarget == distractor
        idle(0);              % Clear the screen.
        eventmarker(Distractor);    %  touched distractor
        trialerror(6);    % land on distractor)
        TrialRecord.User{TrialRecord.CurrentTrialNumber,1}= M;
        End_Trial(); % Termination code is written in the very end of each timing file
        return
    end
%%   
    run_scene(scene3,Hold);
    if ~wth3.Success
        idle(0);
        eventmarker(Touch_Break_Target); % touch break error in scene 3 = choice (eventmarker 34)
        trialerror(9);
    else
        rt = mul2.RT;
        trialerror(0); % correct
        goodmonkey(1000, 'NumReward',NumReward, 'eventmarker',Reward); % 100 ms of juice x 2
    end
    eventmarker(91)
    
else
    eventmarker(19);
    %     trialerror(8); % too many trials in a row - target was not displayed
    %     TrialRecord.User{TrialRecord.CurrentTrialNumber,2}=NaN;
    
end

%% Record M and end trial
idle(200) % to get the end of the movie
TrialRecord.User{TrialRecord.CurrentTrialNumber,1}= M;
End_Trial(); % Termination code is written in the very end of each timing file