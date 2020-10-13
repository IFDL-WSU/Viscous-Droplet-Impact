function [X] = floorremove(image_collection, row_to_delete, rotation_angle)   
    %{ 
    This function takes a collection of processed images, removes the floor and fills in droplets. 
    This is accomplished by:
        1. Rotating the image to align the table with the x-axis.
        2. Deleting the table (floor)
        3. Filling the droplets. 
    This function does sacrifice the very top row of pixels, to quickly fill in the droplet. This shouldn't be a problem as the top row isn't needed for anything.
    %}
    %{
    image_collection = dat_borders;
    row_to_delete = 415;
    rotation_angle = 0.75;
    %}
    

    % Rotate images
    % dat_rotated is going to be used to store rotated images
    dat_rotated = image_collection;
    a = size(image_collection); % used to find the length of for loop
    for i = 1:a(4)
        dat_rotated(:,:,1,i) = imrotate(image_collection(:,:,1,i),...
            rotation_angle,...
            'bilinear', 'crop');
    end


    % Delete table. This will require the user to input the row manually where
    % they believe the table is. 
    dat_deleted_table = dat_rotated(:,:,1,:);
    dat_deleted_table(row_to_delete:end,:,1,:) = 0;
    
    
    
    %{ 
    Fill in droplet.
       1. Draw line across image where floor was.
       2. Draw line on very top pixel.
       3. Fill in holes in the image.
       4. Delete the lines that were added.
    %}
    
    thickness = row_to_delete + 1;
    % Step 1. Draw line across image where floor was.
    dat_added_floor = dat_deleted_table(:,:,:,:);
    dat_added_floor(row_to_delete:thickness,:,:,:) = 1;
    
    % Step 2. Draw line on very top pixel
    dat_added_floor(1,:,:,:) = 1;
    
    % Step 3. Fill in holes.
    dat_filled = dat_added_floor;
    for i = 1:a(4)
        dat_filled(:,:,:,i) = imfill(dat_added_floor(:,:,:,i), 'holes');
    end
    
    % Step 4. Remove added lines.
    dat_final = dat_filled(:,:,:,:);
    dat_final(row_to_delete:thickness,:,:,:) = 0;
    dat_final(1,:,:,:) = 0;
    
    
    X = dat_final;
end
