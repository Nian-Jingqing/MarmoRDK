function [pinkn]=compute_pinkn(const)
% -------------------------------------------------------------------------
% [pinkn]=compute_pinkn(const)
% -------------------------------------------------------------------------
% Goal of the function :
% Compute pink noise stimulus masks (unoriented pink noise) 
% = orientation filtered pink noise
% -------------------------------------------------------------------------
% Input(s) :
% const : general settings
% -------------------------------------------------------------------------
% Output(s):
% pinkn : pink noise images
% -------------------------------------------------------------------------
% Function created by Nina M. Hanning (hanning.nina@gmail.com) 
% and Martin Szinte (martin.szinte@gmail.com)
% Last update : 10 / 04 / 2019
% Project :     StimtTest
% Version :     1.0
% -------------------------------------------------------------------------

% Make raised cosine mask
sizeIm = const.pinkn_rad*2;
imMask = makeRaisedCosineMask(sizeIm,sizeIm,const.sigma);

% Orientation filter
rSigma2 = 0.15; aSigma = const.pinkn_filt;

filt_size = 2.^ceil(log2([sizeIm,sizeIm]));
ImSize_x = filt_size(2); ImSize_y = filt_size(1);

Filter = zeros(ImSize_y,ImSize_x);
for id_X = 1:ImSize_x
    for id_Y = round(ImSize_y/2):ImSize_y
        
        x = id_X - ImSize_x/2; y = id_Y - ImSize_y/2;
        alpha = atan2d(y,x);
        
        r2 = x^2 + y^2; r2 = r2/(ImSize_x*ImSize_y);
        fVal = exp(-(alpha-90)^2/aSigma^2) * exp(-r2/rSigma2);
        
        Filter(id_Y,id_X) = fVal;
        Filter(ImSize_y-id_Y+1,ImSize_x-id_X+1) = fVal;
    end
end
Filter=rot90(Filter);

% Specify when to refresh the noise images
timeRef_vec = zeros(1,const.end_nbf);
timeRef_vec([const.signal_start_nbf : -const.noiseRR_fr : 1, const.signal_start_nbf+const.noiseRR_fr : +const.noiseRR_fr : const.end_nbf]) = 1;


%% Loop and show stimuli


% time loop
for nbf = 1:const.end_nbf
    
    % when time to refresh, make new textures
    if nbf == 1 || timeRef_vec(nbf)
        
        % pink noise image
        noiseIm = make_pinkn(round(const.pinkn_rad));

        % if test time filter test noise image
        if nbf >= const.signal_start_nbf && nbf <= const.signal_end_nbf

            meanSub = mean(noiseIm(:));
            noiseIm_fft = fftshift(fft2(noiseIm-meanSub,filt_size(1),filt_size(2)));    % fft and shift

            noiseIm_fft_filt = Filter .* noiseIm_fft;                                   % apply filter

            noiseIm_filt = real(ifft2(ifftshift(noiseIm_fft_filt)));                    % shift back

            noiseIm_filt = noiseIm_filt(1:size(noiseIm,1),1:size(noiseIm,2));
            noiseIm_filt = noiseIm_filt+meanSub;
            noiseIm_filt = noiseIm_filt-min(noiseIm_filt(:));
            noiseIm_filt = noiseIm_filt./max(noiseIm_filt(:));
            noiseIm      = noiseIm_filt;
        end
            
        % put noise in raised cosine mask
        pinkn(:,:,1,nbf) = noiseIm;
        pinkn(:,:,2,nbf) = imMask;
    end
end

end


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
function raisedCosMask = makeRaisedCosineMask(imX,imY,nCosSteps,apHeight,apWidth)
% function to make a raised cosine mask for a 2D visual stimulus. 
% [imX,imY]: image size; nCosSteps: step number; [apHeight,apWidth]: aperture size;
% by D Aagten-Murphy (2015), edited by NM Hanning (2017)

if nargin == 3;     apHeight = imX; apWidth = apHeight; % aperture has same diameter as Image
elseif nargin == 4; apWidth = apHeight;                 % aperture is smaller than Image and round
end
HWratio = apHeight/apWidth;

imX = ceil(imX/2)*2;imY = ceil(imY/2)*2; % ensure even size
    
if min([imX imY])/2 < nCosSteps; error('Error cosine mask: sigma too big'); end

[X,Y] = meshgrid(-imX/2+1:imX/2,-imY/2+1:imY/2);
radii = sqrt((X/HWratio).^2 + Y.^2);

% Linear transformation to scale the radii values so that the value 
% corresponding to the inner edge of the ramp is equal to (zero x pi) and 
% the value for the outer edge is equal to (1 x pi). 
% The cosine of these values will be 1.0 and zero, respectively.
 
% set inner edge to zero
radii = radii - radii(round(end/2),round(end/2+apWidth/2-nCosSteps)); 

% Do linear transform to set outer edge to pi
outerVal = radii(round(end/2),round(end/2+(apWidth/2-1)));
radii = radii * pi/outerVal ;

radii((radii<=0)) = 0;  	% set values more central than the soft aperture to 0 (ie, cos(0) = 1)
radii((radii>=pi)) = pi;  	% set values more beyond soft aperture to pi (ie, cos(pi) = 0)

raisedCosMask = .5 + .5 * cos(radii);	% cos of all transformed radial values 
end
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
function [noiseIm] = make_pinkn(imR)
% Create 1/f noise image of size [2*imR by 2*imR]
% by D Aagten-Murphy (2015), edited by NM Hanning (2019)

a = rand(imR*2) ;
F = fftshift(fft2(a) );                 % do FFT and shift origin to centre
[x,y] = meshgrid(-(imR):((imR)-1));     % find radial frequencies
radialFreq = sqrt(x.^2 + y.^2);

radialFreq(end/2+1,end/2+1) = 1;        % make sure centre freq is set to 1.
F = F .* (1./radialFreq) ;              % multiply F with inverse of rad Freq.
noiseIm = real( ifft2(fftshift(F)) );   % shift F back and do Inverse FFT

noiseIm = noiseIm - mean(noiseIm(:)); 	% normalise amplitude range
maxVal = max(abs(noiseIm(:)));
noiseIm = noiseIm/(2*maxVal) + .5;

noiseIm = ((noiseIm-.5).*0.9)+0.5;      % slightly reduce contrast to avoid it clipping by chance
end