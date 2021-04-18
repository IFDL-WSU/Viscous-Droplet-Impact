function videoOverlay = maskOverlay(convertedSourceVideo,videoMask,lineThickness,lineColor)
%Check for size error
[videoHeight, videoWidth, ~, videoLength] = size(convertedSourceVideo);
[maskVideoHeight,maskVideoWidth, ~,maskVideoLength] = size(videoMask);
if (videoHeight ~= maskVideoHeight) || (videoWidth ~= maskVideoWidth) || (videoLength ~= maskVideoLength)
    error('Source and Overlay matrix sizes do not match!')
end

%Set Overlay Thickness
if (exist('lineThickness','var'))  %Read in provided thickness
else
    lineThickness = 1;       %Default to 1.
end

%Set Overlay Color
if (exist('lineColor','var'))  %Read in provided colo
    if size(lineColor)~= 3      %Use default if incorrect input type.
        error('lineColor is in incorrect format. Please use an RGB value in the form [R,G,B]')
    end
else
    lineColor = [255,0,0];       %Default to red.
end

%Thicken overlay mask.
SE = strel('diamond',(lineThickness-1)/2);
Mask(:,:,1,:) = imdilate((videoMask),SE);

%Set overlay color onto image using mask.;
falseMask = false(videoHeight,videoWidth,3,videoLength); 
videoOverlay = convertedSourceVideo;
for n = 1:3
    colorMask = falseMask;
    colorMask(:,:,n,:) = Mask;
    videoOverlay(colorMask)=lineColor(n);
end
    
    
