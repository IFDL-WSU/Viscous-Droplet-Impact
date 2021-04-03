function videoRotated = rotateVideo(videoBorders, theta)
% This function rotates all frames of a video by a specified theta. Found
% in calculateTheta function. 

    sizeVideo = size(videoBorders);  % Find size of video
    videoRotated = videoBorders;     % duplicates video for output
    for i = 1:sizeVideo(4)
        videoRotated(:,:,:,i) = imrotate(videoBorders(:,:,:,i), ...
            theta, 'bilinear', 'crop');  % Simple rotation.
    end
end

