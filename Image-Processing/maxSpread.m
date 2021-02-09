function [maxSpreadLeft, maxSpreadRight] = maxSpread(dat)
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
  
  [~,~,~,d] = size(dat);
  
  spreadLeft = zeros(d,1);
  spreadRight = spreadLeft;
  
  x = regionprops(dat(:,:,:,1), 'Centroid');
  center = x.Centroid(1);
  
  for i = 1:d
      m = regionprops(dat(:,:,:,i), 'Extrema');

      spreadLeft(i)  = center - m(1,1).Extrema(6,1);
      spreadRight(i) = m(1,1).Extrema(5,1) - center; 
  end
  
  maxSpreadLeft  = max(spreadLeft);
  maxSpreadRight = max(spreadRight);
end
