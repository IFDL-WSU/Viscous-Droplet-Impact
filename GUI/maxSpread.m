function [maxSpreadLeft, maxSpreadRight, spreadLeft, spreadRight, x] = maxSpread(dat, floor)
  %{
  This function finds the max spread radius (in pixels)
  
  d -          Number of frames in the data set.
  spread -     dx1 matrix of zeros that is filled in with the radius of the droplet in each frame.
  max_spread - This is the maximum radius (in pixels) of the spread matrix.
      Extrema:
      1 - top-left 
      2 - top-right 
      3 - right-top 
      4 - right-bottom 
      5 - bottom-right 
      6 - bottom-left 
      7 - left-bottom 
      8 - left-top
 
  %}


  [~,~,~,d] = size(dat);        % Gathers length of video

  % Initializes a frame no.
  frame = 0;  
  
  % Finds the last frame no. without a partial droplet. (completely black)
  for i = 1:d
      if dat(:,:,:,i) == 0
          frame = i;
      end
  end 
  
  
  % New dataset and size
  X = dat(:,:,:,frame+1:end);
  [~,~,~,e] = size(X);
  
  
  % Find when droplet impacts floor
  frame = 1;
  
  for i = 1:d
      if dat(floor-1,:,:,i) == 0
          frame = i;
      end
  end
  
  
  
  
  
  
  spreadLeft = NaN(d,1);    % Initializes vector for all radii l/r
  spreadRight = spreadLeft;
  
  
  % Find the center of the droplet. 
  x = regionprops(X(:,:,:,1), 'Centroid');
  center = x.Centroid(1);
  difference = d-e;    % no. of blacked frames.
  
  
  % Calculates the radius of droplet each frame. 
  for i = 1:e
      m = regionprops(X(:,:,:,i), 'Extrema');
      %{
      Records the pixel distance between the extreme points relative to the
      center of mass. The vectors are the total length of the video and the
      difference is the gap in black frames. 
      %}
      spreadLeft(i+difference)  = center - m(1,1).Extrema(6,1); 
      spreadRight(i+difference) = m(1,1).Extrema(5,1) - center;
  end
  
  spreadLeft(1:frame,:) = NaN;
  spreadRight(1:frame,:) = NaN;
  
  
  maxSpreadLeft  = max(spreadLeft);  % Finds the maximum radii
  maxSpreadRight = max(spreadRight);
end
