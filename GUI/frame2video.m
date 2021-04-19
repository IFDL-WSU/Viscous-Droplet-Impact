function frame2video(videoMatrix,fileName,filePath,frameRate)
[~,  ~,  videoMode,  videoLength] = size(videoMatrix);

%Error catching: the uiputfile window was closed. Do nothing.
    if isa(fileName,'double')== 1
        return
    end

%Select Correct Video Profile
switch videoMode
    case 3
        fileExt = 'Uncompressed AVI';
    case 1
        fileExt = 'Grayscale AVI';
    otherwise
        error("videoMatrix has an incompatible videoMode. Please provide a greyscale videoMatrix with a videoMode of 1, or a full color videoMatrix with a videoMode of 3.")
end

%Set Frame Rate
if (~exist('frameRate','var'))  %Read in provided frame rate
    frameRate = 30;       %Default to 1.
end

%Remove extension in fileName. Ignore anything after a period.
splitStr = split(fileName,'.');
fileName = splitStr(1);

%Create video object
v = VideoWriter(append(filePath,"/", fileName),fileExt);
v.FrameRate = frameRate;
open(v)

%Write each frame to the video file
for i = 1:videoLength
    switch videoMode
        case 3
            frameImage=videoMatrix(:,:,:,i);
        case 1
            frameImage=mat2gray(videoMatrix(:,:,1,i));
    end
    writeVideo(v,frameImage);
end
close(v);

end
