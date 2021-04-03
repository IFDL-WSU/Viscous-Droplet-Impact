function videoNoNoise = removeNoise(videoBorders)
% This function assumes that the droplet border will drastically decrease
% in size on impact, and the function will paint it black for processing
% later. The result of this function will be a video dataset with only
% frames showing the droplet prior to impact (fullsize droplet).

sizeVideo = size(videoBorders);  % Finds the size of the video (y, x, color, no frames)
videoNoNoise = videoBorders;     % Creates a duplicate dataset for manipulation

for i = 1:sizeVideo(4)
    regions = regionprops(videoBorders(:,:,:,i));  % Creates a regionprops() of current frame
    sizeRegions = size(regions);                   % Determines the number of objects (white spots)
    for j = 1:sizeRegions(1)
        
        % Determines if an object is small (assuming the droplet is larger
        % than 30000 pixels^2
        if regions(j).Area < 30000
            x1 = regions(j).BoundingBox(1);       % Find x1 coordinate
            x2 = x1 + regions(j).BoundingBox(3);  % Find x2 coordinate
            y1 = regions(j).BoundingBox(2);       % Find y1 coordinate
            y2 = y1 + regions(j).BoundingBox(4);  % Find y2 coordinate
            videoNoNoise(y1:y2, x1:x2, :, i) = 0; % Changes box with x1, y1, x2, and y2 coordinates to all black.
    end 
end

    disp("Finshed removeNoise()");  % displays step finished for ease of use.
end

