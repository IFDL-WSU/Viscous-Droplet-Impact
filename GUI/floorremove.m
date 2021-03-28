function [videoFloorRemoved] = floorremove(videoBorders, floorPixel, floorAngle)   
    %{ 
    This function takes a collection of processed images, removes the floor and fills in droplets. 
    This is accomplished by:
        1. Rotating the image to align the table with the x-axis.
        2. Deleting the table (floor)
        3. Filling the droplets. 
    This function removes partial droplets (since they are useless). It also creates an all black frame when there is no full droplet. These frames will be deleted later.
    %}
    %{
    image_collection = dat_borders;
    row_to_delete = 415;
    rotation_angle = 0.75;
    %}
    

    % Rotate images
    % dat_rotated is going to be used to store rotated images
    dat_rotated = videoBorders;
    [~,~,~,videoLength] = size(videoBorders); % used to find the length of for loop
    for frame = 1:videoLength
        dat_rotated(:,:,1,frame) = imrotate(videoBorders(:,:,1,frame),...
            floorAngle,...
            'bilinear', 'crop');
    end


    % Delete table. This will require the user to input the row manually where
    % they believe the table is. 
    dat_deleted_table = dat_rotated(:,:,1,:);
    dat_deleted_table(floorPixel:end,:,1,:) = 0;
    
    
    
    %{ 
    Fill in droplet.
       1. Draw line across image where floor was.
       2. Draw line on very top pixel.
       3. Fill in holes in the image.
       4. Delete the lines that were added.
       5. Clear the borders (get rid of partial droplets)
    %}
    
    thickness = floorPixel + 1;
    % Step 1. Draw line across image where floor was.
    dat_added_floor = dat_deleted_table(:,:,:,:);
    dat_added_floor(floorPixel:thickness,:,:,:) = 1;
    
    % Step 2. Draw line on very top pixel
    dat_added_floor(1,:,:,:) = 1;
    
    % Step 3. Fill in holes.
    dat_filled = dat_added_floor;
    for frame = 1:videoLength
        dat_filled(:,:,:,frame) = imfill(dat_added_floor(:,:,:,frame), 'holes');
    end
    
    % Step 4. Remove added lines.
    dat_final = dat_filled(:,:,:,:);
    dat_final(floorPixel:thickness,:,:,:) = 0;
    
    % Step 5. Clear the borders. Remove small objects.
    dat_final = bwareaopen(dat_final, 150,4);
    %seD = strel('diamond',1);
    %dat_final = imerode(dat_final,seD);
    videoFloorRemoved = dat_final;
    for frame = 1:videoLength
        videoFloorRemoved(:,:,:,frame) = imclearborder(videoFloorRemoved(:,:,:,frame), 4);
    end
end
