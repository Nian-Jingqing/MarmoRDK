function [expDes,const]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 04 / 05 / 2021
% Project :     MarmStim
% Version :     3.0
% ----------------------------------------------------------------------

%% Experimental random variables
rng('default');rng('shuffle');

% Var 1 : stim orientation (2 modalities)
% ===== 
expDes.oneV             =   [1;2];
expDes.txt_var1         =   {'0 deg','180 deg'};
% 01 = 0 deg (right)
% 02 = 180 deg (left)

% Var 2 : signal soa (5 modalities)
% =====
expDes.twoV             =   [1:const.signal_soa_num]';
expDes.txt_var2         =   {'75 ms','136 ms','258 ms','379 ms','500 ms'};
% 01 =  ~75 msec
% 02 = ~136 msec
% 03 = ~258 msec
% 04 = ~379 msec
% 05 =  500 msec

% Var 3 : signal coherence (5 modalities)
% =====
expDes.threeV           =   [1:const.kappa_levels]';
expDes.txt_var3         =   {'kappa: 0','kappa: 2.5','kappa: 5.0','kappa: 7.5','kappa: 10'};
% 01 = kappa: 0 (random)
% 02 = kappa: 2.5
% 03 = kappa: 5.0
% 04 = kappa: 7.5
% 05 = kappa: 10

% Var 4 : random stim example (20 modalities)
expDes.fourV            =   [1:const.example_num]';
expDes.txt_var4         =   {'example: 01','example: 02','example: 03','example: 04','example: 05',...
                             'example: 06','example: 07','example: 08','example: 09','example: 10',...
                             'example: 11','example: 12','example: 13','example: 14','example: 15',...
                             'example:  16','example: 17','example: 18','example: 19','example: 20'};
% 01 = example 1
% 02 = example 2
% ...
% 20 = example 20

%% Experimental configuration :
expDes.numVar = 4;

% Define condition types
t_trial = 0;
for var1 = 1:numel(expDes.oneV)
    for var2 = 1:numel(expDes.twoV)
        for var3 = 1:numel(expDes.threeV)
            for var4 = 1:numel(expDes.fourV)
                t_trial = t_trial+1;
                expDes.expMat(t_trial,:) = [var1, var2, var3, var4];
            end
        end
    end
end

%% save file for videos and images
if const.mkVideo
    expDes.expMat = [];
    end_filename = '';
    for var_num = 1:expDes.numVar
        expDes.expMat(1,var_num) = input(sprintf('\nVar %i : ',var_num));
        end_filename = strcat(end_filename,sprintf('_var%i-%i',var_num,expDes.expMat(1,var_num)));

    end
    const.movie_image_file  =   sprintf('others/vid/vid%s',end_filename);
    const.movie_file        =   sprintf('others/vid%s.mp4',end_filename);
end

if const.ml_material
    for var1 = 1:numel(expDes.oneV)
        for var2 = 1:numel(expDes.twoV)
            for var3 = 1:numel(expDes.threeV)
                for var4 = 1:numel(expDes.fourV)
                    
                    dir_filename = sprintf('ml/var1-%i-var2-%i-var3-%i-var4-%i',var1,var2,var3,var4);
                    dir_filename2 = sprintf('ml/var1-%i-var2-%i-var3-%i-var4-%i',var1,var2,var3,var4);
                    
                    if ~isdir(dir_filename)
                        mkdir(dir_filename)
                    end                    
                    if ~isdir(dir_filename2)
                        mkdir(dir_filename2)
                    end
                    const.ml_file_vid_t1{var1,var2,var3,var4} = sprintf('%s/vid_t1.avi',dir_filename);   % wait touch
                    const.ml_file_vid_t2{var1,var2,var3,var4} = sprintf('%s/vid_t2.avi',dir_filename);   % fix feedback
                    const.ml_file_vid_t3{var1,var2,var3,var4} = sprintf('%s/vid_t3.avi',dir_filename);   % rdk vid
                    const.ml_file_vid_t4{var1,var2,var3,var4} = sprintf('%s/vid_t4.avi',dir_filename);   % button response
                    const.ml_file_vid_t5{var1,var2,var3,var4} = sprintf('%s/vid_t5.avi',dir_filename);   % button response
                end
            end
        end
    end
end

end