function draw_buttons(scr,const,targetX,targetY,position)
% ----------------------------------------------------------------------
% draw_buttons(scr,const,targetX,targetY,position)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw touch button in the center or to the left/right of the screen
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% targetX: target coordinate X
% targetY: target coordinate Y
% position : 'center' or 'sides'
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 15 / 05 / 2021
% Project :     MarmStim
% Version :     2.0
% ----------------------------------------------------------------------

if strcmp(position,'center')
    Screen('DrawDots',scr.main,[targetX,targetY],const.button_out_rim_rad*2, const.dot_color , [], 3);
    Screen('DrawDots',scr.main,[targetX,targetY],const.button_rim_rad*2, const.button_color, [], 3);
elseif strcmp(position,'sides')
    Screen('DrawDots',scr.main,[targetX-const.button_dist,targetY],const.button_out_rim_rad*2, const.dot_color , [], 3);
    Screen('DrawDots',scr.main,[targetX-const.button_dist,targetY],const.button_rim_rad*2, const.button_color, [], 3);
    
    Screen('DrawDots',scr.main,[targetX+const.button_dist,targetY],const.button_out_rim_rad*2, const.dot_color , [], 3);
    Screen('DrawDots',scr.main,[targetX+const.button_dist,targetY],const.button_rim_rad*2, const.button_color, [], 3);
    
end

end