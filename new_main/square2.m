function [BW,maskedRGBImage] = square2(RGB)
%square2 
%   threshold RGB image by using colorThresholder app.
%   function returns a binary image.
% 
%   See also colorThresholder.


% Convert RGB image to chosen color space
I = rgb2lab(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 37.301;

% Define thresholds for channel 2 based on histogram settings
channel2Min = -17.440;
channel2Max = 30.795;

% Define thresholds for channel 3 based on histogram settings
channel3Min = -32.872;
channel3Max = 45.585;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 48.077;

% Define thresholds for channel 2 based on histogram settings
channel2Min = -51.585;
channel2Max = 75.692;

% Define thresholds for channel 3 based on histogram settings
channel3Min = -68.805;
channel3Max = 92.200;


% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
