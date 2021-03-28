function convertedSourceVideo = convertSource(videoSource, floorAngle)
%% Convert source image to TrueColor image. %%
[videoHeight,videoWidth,videoMode,videoLength]=size(videoSource);
convertedSourceVideo = uint8(zeros(videoHeight,videoWidth,3,videoLength));

if ndims(videoSource) < 4
    error('Unexpected Source Matrix format. Please provide a grayscale image, an RGB image, or a binary image. ')
elseif islogical(videoSource) == 1
    for n = 1:3
        convertedSourceVideo(:,:,n,:) = im2uint8(videoSource(:,:,1,:));
    end
elseif videoMode == 1
    for n = 1:3
        convertedSourceVideo(:,:,n,:) = im2uint8(videoSource(:,:,1,:));
    end
elseif (videoMode == 3)
    if isa(videoSource,'uint8') == 0
        convertedSourceVideo(:,:,:,:) = im2uint8(videoSource(:,:,:,:));
    end
else
    error('Unexpected Source Matrix format. Please provide a grayscale image, an RGB image, or a binary image. ')
end

%% Rotate TrueColor Image to match rotated borders.
if floorAngle ~= 0
    for frame = 1:videoLength
        convertedSourceVideo(:,:,:,frame) = ...
        imrotate(convertedSourceVideo(:,:,:,frame),floorAngle,'bilinear', 'crop');
    end
end
end