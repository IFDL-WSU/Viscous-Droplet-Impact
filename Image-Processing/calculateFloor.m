function [calculatedFloor, sampleFrame] = calculateFloor(lastFrame, lastFrameNo, videoRotatedInput)
%{ 
This function attempts to calculate the floor
%}

    referenceFrame = videoRotatedInput(:,:,:,lastFrameNo-1); % Frame before impact
    sizeVideo = size(videoRotatedInput);
    regions = regionprops(referenceFrame);
    sizeRegion = size(regions);
    whatRegion = 1;
    area = 0;   % saves the largest regionprops area
    % This loop finds the region with the greatest area (droplet)
    for i = 2:sizeRegion(1)
        if regions(i).Area > area
            area = regions(i).Area;
            whatRegion = i;
        end
    end    
    
    % Calculates the box coordinates of the droplet before impact
    x1 = ceil(regions(whatRegion).BoundingBox(1));
    y1 = ceil(regions(whatRegion).BoundingBox(2));
    x2 = ceil((x1 + regions(whatRegion).BoundingBox(3)) * 1.1);
    y2 = ceil((y1 + regions(whatRegion).BoundingBox(4)) * 1.1);
    
   
    deltaPixels = 25; % adds this many pixels to the bottom of the droplet box
    
    % Deletes everything in the impact frame that is not in the droplet box
    videoRotatedInput(:,1:x1,:,lastFrameNo+1) = 0;
    videoRotatedInput(:,sizeVideo(2)-x1:sizeVideo(2),:,lastFrameNo+1) = 0;
    videoRotatedInput(1:y1,:,:,lastFrameNo+1) = 0;
    videoRotatedInput(y2+deltaPixels:sizeVideo(1),:,:,lastFrameNo+1) = 0; 
    sampleFrame = videoRotatedInput(:,:,:,lastFrameNo+1); % Saves the impact frame with everything deleted so we know what the program was looking at. 
    
    
    % Finds the lowest point of the droplet in the reference frame
    regions = regionprops(referenceFrame, 'Extrema');

    lowestPoint = 0;   % Declares lowest point variable
    % Checks if left or right corners are lower (should be equal due to
    % theta and rotation
    if regions(whatRegion,1).Extrema(5,2) > regions(whatRegion,1).Extrema(6,2)
        lowestPoint = ceil(regions(whatRegion,1).Extrema(5,2));
    else
        lowestPoint = ceil(regions(whatRegion,1).Extrema(6,2));
    end
    
    

    


    
    
    
    
    % declare distance variables for loop
    d1 = 0;
    d2 = 0;
    % variable to stop loop
    loopDone = 0;
    % declare lowestPointBegin
    lowestPointBegin = lowestPoint;
    
    % Error checking. This will display if the lowest point is being saved
    % as the bottom of the frame. If this happens, the user needs to guess
    % the pixel of the floor
    if lowestPoint >= sizeVideo(1)
        fprintf("\n\n\n\nError: Automated function calculated floor at the bottom of the frame. Floor requires user's input.\n\nWarning: If this floor value is used then data will be incorrect.\n");
        loopDone = 1;
        calculatedFloor = lowestPoint;
    end
    
    %{
    This loop calculates the distance between the bottom left and bottom
    right points on the reference frame. It first picks the lowest point
    from the frame prior and measures that distance d1. It then finds the
    distance on the pixel below d2. When d2 is greater than d1, it ends the
    loop and saves the pixel of d1 as the floor. 

    This works because the droplet reflects on the ground and the border 
    mirrors the droplet at the floor value. The border follows the curve 
    of the droplet as it closes in. Once it hits the floor, the curve
    begins to expand again. 
    
    Note: This does not work for all videos and the user must verify that
    the automated function worked properly. 
    %}
    while loopDone == 0
        d1 = find(videoRotatedInput(lowestPoint,:,:,lastFrameNo+1),1,'last') - ...
            find(videoRotatedInput(lowestPoint,:,:,lastFrameNo+1),1,'first');
        d2 = find(videoRotatedInput(lowestPoint+1,:,:,lastFrameNo+1),1,'last') - ...
            find(videoRotatedInput(lowestPoint+1,:,:,lastFrameNo+1),1,'first');
        if d2 >= d1
            calculatedFloor = lowestPoint + 1;
            loopDone = 1;
        end
        if lowestPoint < sizeVideo(1) - 1
            lowestPoint = lowestPoint + 1;
        else
            calculatedFloor = lowestPointBegin;
            loopDone = 1;
        end
        
    end
end

