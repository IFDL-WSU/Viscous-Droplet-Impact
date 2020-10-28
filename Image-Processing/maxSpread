function max_spread = maxSpread(dat)
  %{
  This function finds the max spread radius (in pixels)
  
  d -          Number of frames in the data set.
  spread -     dx1 matrix of zeros that is filled in with the radius of the droplet in each frame.
  max_spread - This is the maximum radius (in pixels) of the spread matrix.
  %}
  
  [~,~,~,d] = size(dat) 
  
  spread = zeros(d,1)
  
  for i = 1:d
      m = regionprops(dat(:,:,:,i), 'Extrema');
      spread(i) = (m(1,1).Extrema(5,1) - m(1,1).Extrema(6,1))/2; 
  end
  
  max_spread = max(spread)
end
