function [const] = runExp(scr,const,expDes,my_key)
% ----------------------------------------------------------------------
% [const] = runExp(scr,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch experiement trials
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : experimental design
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 05 / 2021
% Project :     MarmStim
% Version :     2.0
% ----------------------------------------------------------------------

% Configuration of videos
% -----------------------
if const.mkVideo
    const.vid_obj           =   VideoWriter(const.movie_file,'MPEG-4');
    const.vid_obj.FrameRate =   66;
	const.vid_obj.Quality   =   100;
    open(const.vid_obj);
end

% First mouse config
% ------------------
if const.debug == 0
    HideCursor;
    for keyb = 1:size(my_key.keyboard_idx,2)
        KbQueueFlush(my_key.keyboard_idx(keyb));
    end
end

% First keyboard config
% ---------------------
for keyb = 1:size(my_key.keyboard_idx,2)
    KbQueueFlush(my_key.keyboard_idx(keyb));
end

% Main trial loop
% ---------------

for t_trial = 1:size(expDes.expMat,1)
    runTrials(scr,const,expDes,my_key,t_trial);
end


end