function videoBorders = borders(videoSource)
% extract dimensions of video matrix
videoSize = size(videoSource);

for i = 1:videoSize(4)
    % Selects each frame and uploads it as a single double image.
    % *32 multiplier brightens the image to reduce inconsistancies. 
    frame = im2double(videoSource(:,:,:,i))*32;
    % Convert back to uint8
    frame = im2uint8(frame);
    
    % Use the processing techniques from the exercise we did the other day.
    [~, threshold] = edge(frame, 'sobel');
    fudgeFactor = 0.25;
    BWs = edge(frame, 'prewitt', threshold * fudgeFactor);
    
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    BWsdil = imdilate(BWs, [se90 se0]);

    BWdfill = imfill(BWsdil, 'holes');
    
    %Removed BWnobord since it deletes the droplet if it intersects the
    %floor or ceiling. Will add back in once that is addressed.
    %BWnobord = imclearborder(BWdfill, 8);
    
    %Remove small objects
    BWnosmall = bwareaopen(BWdfill, 150);
    
    %Return processed images in the same format as the input images.
    videoBorders(:,:,:,i) = BWnosmall;
end
