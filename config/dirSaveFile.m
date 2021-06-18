function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files name and fid.
% ----------------------------------------------------------------------
% Input(s) :
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

% Movie file
if const.mkVideo
    if ~isdir('others/vid/')
        mkdir('others/vid/')
    end
end

% monkeylogic condition file
const.ml_savefile = sprintf('ml/%s.mat',const.expName);

end