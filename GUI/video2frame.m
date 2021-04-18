function [videoSource, videoSize] = video2frame(videoFile)
% VIDEO2FRAME Converts a greyscale video file to a matrix of greyscale frames.
%    [videoSource,videoSize] = VIDEO2FRAME('MEDIA.avi') converts MEDIA.avi to 4D
%    matrix called videoSource, and reports the dimensions of the video videoSize.
%
% An indivigual frame can be shown using:
%    imshow( videoSource(:,:,:,frame) )
%
% The dimensions of the video are saved as:
%    [videoHeight, videoWidth, videoMode, videoLength]
%       where videoMode is the type of image, and videoLength is the frame
%       count.
%
%   See also IMSHOW

    Video = VideoReader(videoFile);     %Video Object
    videoSource = read(Video, [1,Inf]); %4D Frame Matrix
    [videoHeight,videoWidth,videoMode,videoLength] = size(videoSource);  %Number of frames.
    videoSize = [videoHeight,videoWidth,videoMode,videoLength];      %Video dimensions
end
