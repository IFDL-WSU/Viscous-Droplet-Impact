function velocity = calculateVelocity(dat)
    %{
    This function calculates the velocity of the radius. It accomplishes
    this by finding the number of pixels between the bottom left and bottom
    right positions and subtracts that from the previous frame.

    'Extrema' feature in regionprops is used to find the most extreme
    points of two frames. The diameter is determined and then divided by
    two to get radius. Then velocity(i) saves the velocity in pixels/frame.
    This conversion will need to be accomplished later.
    
    The final part of this function is calculating the moving velocity. This is done to filter the velocity data.

    d - length of the data frames.
    DoF - Degrees of freedom. This is the number of delta pixels we can
          calculate.
    velocity - is the difference in pixels per frame.
    position1/2 - variables to save the 'Extrema' features (8x2 double)
    radius1/2 - stores the radius of each frame.
    velocityAvg - vector of the moving average.
    %}

    [~,~,~,d] = size(dat);
    DoF = d-1;
    
    velocity = zeros(DoF,1);
    
    for i = 1:DoF
        position1 = regionprops(dat4(:,:,:,i), 'Extrema');
        position2 = regionprops(dat4(:,:,:,i+1), 'Extrema');
        radius1 = (position1(1,1).Extrema(5,1)-position1(1,1).Extrema(6,1))/2;
        radius2 = (position2(1,1).Extrema(5,1)-position2(1,1).Extrema(6,1))/2;
        velocity(i) = radius2-radius1; 
    end
    
    # Calculate the moving velocity
    velocityAvg = zeros(d,1);
    for i = 9:d
        velocityAvg(i) = (velocity(i) + ...
            velocity(i-1) + velocity(i-2) +...
            velocity(i-3) + velocity(i-4) +...
            velocity(i-5) + velocity(i-6) +...
            velocity(i-7) + velocity(i-8))/9;
    end
    return(velocityAvg)
end 
