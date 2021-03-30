function videoCalculatedFloorRemoved = removeCalculatedFloor(videoRotated, calculatedFloor, lastFrameNo)

    %{ 
    This function simply deletes everything underneath the floor value. 
    
    It begins by drawing a line at the floor level. Using the line to fill
    in the partial droplet. Then deleting the line and everything under the
    floor. 
    %}
    sizeVideo = size(videoRotated);
    videoCalculatedFloorRemoved = videoRotated;
    for i = 1:sizeVideo(4)
        videoCalculatedFloorRemoved(calculatedFloor:sizeVideo(1),:,:,i) = 0;
    end
    
    for i = lastFrameNo:sizeVideo(4)
        videoCalculatedFloorRemoved(calculatedFloor,:,:,i) = 1;
        videoCalculatedFloorRemoved(:,:,:,i) = imfill(videoCalculatedFloorRemoved(:,:,:,i), 'holes');
        videoCalculatedFloorRemoved(calculatedFloor,:,:,i) = 0;
    end
    
end

