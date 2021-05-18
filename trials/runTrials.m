function runTrials(scr,const,expDes,my_key,t_trial)
% ----------------------------------------------------------------------
% runTrials(scr,const,expDes,my_key,t_trial)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : experimental design
% my_key : structure containing keyboard configurations
% t_trial : trial meter
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 15 / 05 / 2021
% Project :     MarmStim
% Version :     2.0
% ----------------------------------------------------------------------

% specify trials
vid_num = 0;
var1 = expDes.expMat(t_trial,1);    % signal direction
var2 = expDes.expMat(t_trial,2);    % signal soa
var3 = expDes.expMat(t_trial,3);    % signal kappa
var4 = expDes.expMat(t_trial,4);    % signal example
rdk = const.rdk{var1,var2,var3,var4};
if const.ml_material
    ml_vid_obj_t1 = VideoWriter(const.ml_file_vid_t1{var1,var2,var3,var4},'MPEG-4');
    ml_vid_obj_t1.FrameRate =   66;
	ml_vid_obj_t1.Quality   =   100;
    
    ml_vid_obj_t2 = VideoWriter(const.ml_file_vid_t2{var1,var2,var3,var4},'MPEG-4');
    ml_vid_obj_t2.FrameRate =   66;
	ml_vid_obj_t2.Quality   =   100;
    
    ml_vid_obj_t3 = VideoWriter(const.ml_file_vid_t3{var1,var2,var3,var4},'MPEG-4');
    ml_vid_obj_t3.FrameRate =   66;
	ml_vid_obj_t3.Quality   =   100;
    
    ml_vid_obj_t4 = VideoWriter(const.ml_file_vid_t4{var1,var2,var3,var4},'MPEG-4');
    ml_vid_obj_t4.FrameRate =   66;
	ml_vid_obj_t4.Quality   =   100;
    
    ml_vid_obj_t5 = VideoWriter(const.ml_file_vid_t5{var1,var2,var3,var4},'MPEG-4');
    ml_vid_obj_t5.FrameRate =   66;
	ml_vid_obj_t5.Quality   =   100;
end


% Draw button press
% -----------------
press_button_start = 0;
press_space = 0;
while ~press_button_start
    if press_space
        press_button_start = 1;
        press_space = 0;
    end
    Screen('FillRect',scr.main,const.gray);
    draw_buttons(scr,const,const.button_coords(1),const.button_coords(2),'center')
    Screen('Flip',scr.main);
    
    % Check keyboard
    % --------------
    keyPressed =   0;
    keyCode =   zeros(1,my_key.keyCodeNum);
    for keyb = 1:size(my_key.keyboard_idx,2)
        [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
        keyPressed = keyPressed+keyP;
        keyCode = keyCode+keyC;
    end
    if keyPressed
        if keyCode(my_key.escape)
            overDone(const);
        elseif keyCode(my_key.space)
            press_space = 1;
        end
    end
    if const.mkVideo
        vid_num = vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,vid_num))
        writeVideo(const.vid_obj,image_vid);
    end
    if const.ml_material
        press_space = 1;
        image_vid = Screen('GetImage', scr.main);
        if press_space == 1
            open(ml_vid_obj_t1);
            writeVideo(ml_vid_obj_t1,image_vid);
        end
        close(ml_vid_obj_t1);
    end
end

% Draw fixation dot during reward
% -------------------------------
for nbf = 1:const.reward1_nbf
    Screen('FillRect',scr.main,const.gray);
    draw_fix(scr,const,const.stim_coords(1),const.stim_coords(2))
    Screen('Flip',scr.main);
    
    if const.mkVideo
        vid_num = vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,vid_num))
        writeVideo(const.vid_obj,image_vid);
    end
    
    if const.ml_material
        open(ml_vid_obj_t2);
        image_vid = Screen('GetImage', scr.main);
        writeVideo(ml_vid_obj_t2,image_vid);
        close(ml_vid_obj_t2);
        break
    end
end

% Draw stim
% ---------
for nbf = 1:size(rdk.posi,2)
    Screen('FillRect',scr.main,const.gray);
    Screen('DrawDots',scr.main, round(rdk.posi{nbf})', rdk.siz, rdk.col, rdk.cent,2);
    Screen('Flip',scr.main);
    if const.mkVideo
        vid_num = vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,vid_num))
        writeVideo(const.vid_obj,image_vid);
    end
    
    if const.ml_material
        if nbf == 1
            open(ml_vid_obj_t3);
        end
        image_vid = Screen('GetImage', scr.main);
        writeVideo(ml_vid_obj_t3,image_vid);
        if nbf == size(rdk.posi,2)
            close(ml_vid_obj_t3);
        end
    end
    
end

% Response buttons
% ----------------
press_button_start = 0;
nbf = 0;
while ~press_button_start
    nbf = nbf + 1;
    Screen('FillRect',scr.main,const.gray);
    draw_buttons(scr,const,const.button_coords(1),const.button_coords(2),'sides')
    Screen('Flip',scr.main);

    % Check keyboard
    % --------------
    keyPressed =   0;
    keyCode =   zeros(1,my_key.keyCodeNum);
    for keyb = 1:size(my_key.keyboard_idx,2)
        [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
        keyPressed = keyPressed+keyP;
        keyCode = keyCode+keyC;
    end
    if keyPressed
        if keyCode(my_key.escape)
            overDone(const);
        elseif keyCode(my_key.left)
            press_button_start = 1;
            if var1 == 1 ;      resp = 0;
            elseif var1 == 2;   resp = 1;
            end
        elseif keyCode(my_key.right)
            press_button_start = 1;
            if var1 == 1 ;      resp = 1;
            elseif var1 == 1;   resp = 0;
            end
        end
    end
    
    if nbf == const.resp_nbf
        press_button_start = 1;
        resp = -1;
    end
    
    if const.mkVideo
        vid_num = vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,vid_num))
        writeVideo(const.vid_obj,image_vid);
    end
    
    if const.ml_material
        open(ml_vid_obj_t4);
        press_button_start = 1;
        image_vid = Screen('GetImage', scr.main);
        if press_button_start == 1
            writeVideo(ml_vid_obj_t4,image_vid);
        end
        close(ml_vid_obj_t4);
    end
end

% Reward and inter trial interval
% -------------------------------
for nbf = 1:const.reward2_nbf
    Screen('FillRect',scr.main,const.gray);
    Screen('Flip',scr.main);
    
    if const.mkVideo
        vid_num = vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png',const.movie_image_file,vid_num))
        writeVideo(const.vid_obj,image_vid);
    end
    
    
    if const.ml_material
        open(ml_vid_obj_t5);
        image_vid = Screen('GetImage', scr.main);
        writeVideo(ml_vid_obj_t5,image_vid);
        if nbf == size(rdk.posi,2)
            close(ml_vid_obj_t5);
        end
    end
    
end

end