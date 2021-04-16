function [videoFinal] = floorremove(videoBorders, rowToDelete, rotationAngle)   
    %{ 
    This function takes a collection of processed images, removes the floor and fills in droplets. 
    This is accomplished by:
        1. Rotating the image to align the table with the x-axis.
        2. Deleting the table (floor)
        3. Filling the droplets. 
    This function removes partial droplets (since they are useless). It also creates an all black frame when there is no full droplet. These frames will be deleted later.
    %}
    %{
    rowToDelete = 415;
    rotationAngle = 0.75;
    %}
    

    % Rotate images
    % dat_rotated is going to be used to store rotated images
    videoRotated = videoBorders;
    a = size(videoBorders); % used to find the length of for loop
    for i = 1:a(4)
        videoRotated(:,:,1,i) = imrotate(videoBorders(:,:,:,i),...
            rotationAngle, 'bilinear', 'crop');
    end


    % Delete table. This will require the user to input the row manually where
    % they believe the table is. 
    videoDeletedFloor = videoRotated(:,:,1,:);
    videoDeletedFloor(rowToDelete:end,:,1,:) = 0;
    
    
    
    %{ 
    Fill in droplet.
       1. Draw line across image where floor was.
       2. Draw line on very top pixel.
       3. Fill in holes in the image.
       4. Delete the lines that were added.
       5. Clear the borders (get rid of partial droplets)
    %}
    
    thickness = rowToDelete + 1;
    % Step 1. Draw line across image where floor was.
    videoAddedFloor = videoDeletedFloor(:,:,:,:);
    videoAddedFloor(rowToDelete:thickness,:,:,:) = 1;
    
    % Step 2. Draw line on very top pixel
    videoAddedFloor(1,:,:,:) = 1;
    
    % Step 3. Fill in holes.
    videoFilled = videoAddedFloor;
    for i = 1:a(4)
        videoFilled(:,:,:,i) = imfill(videoAddedFloor(:,:,:,i), 'holes');
    end
    
    % Step 4. Remove added lines.
    videoLinesRemoved = videoFilled(:,:,:,:);
    videoLinesRemoved(rowToDelete:thickness,:,:,:) = 0;
    
    % Step 5. Clear the borders. Remove small objects.
    videoLinesRemoved = bwareaopen(videoLinesRemoved, 150,4);
    %seD = strel('diamond',1);
    %dat_final = imerode(dat_final,seD);
    videoFinal = videoLinesRemoved;
    for i = 1:a(4)
        videoFinal(:,:,:,i) = imclearborder(videoFinal(:,:,:,i), 4);
    end
end
