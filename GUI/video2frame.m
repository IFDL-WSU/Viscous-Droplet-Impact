function [fMatrix, fRange] = video2frame(vFile)
% VIDEO2FRAME Converts a greyscale video file to a matrix of greyscale frames.
%    [M,R] = VIDEO2FRAME('MEDIA.avi') converts MEDIA.avi to 4D
%    matrix M of frames, and reports the number of frames R.
%
% An indivigual frame can be shown using:
%    imshow( M(:,:,:,frame) )
%  
%   See also IMSHOW

    Video = VideoReader(vFile);     %Video Object
    fMatrix = read(Video, [1,Inf]); %4D Frame Matrix
    [~,~,~,fRange] = size(fMatrix); %Number of frames.
end
