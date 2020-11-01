function [data,impactVel] = fallVelocity(image_collection)
% This function finds the centroid location data (pixel location,
% the centroid velocity data
% and the impact velocity.
% 
% The data matrix saves as follows: (per frame)
% data(:,:,frame)
%[Centroid1_X, Centroid2_X, Centroid3_X, Centroid4_X;
% Centroid1_Y, Centroid2_Y, Centroid3_Y, Centroid4_y;
% Velocity1_X, Velocity2_X, Velocity3_X, Velocity4_X;
% Velocity1_Y, Velocity2_Y, Velocity3_Y, Velocity4_Y]
%
% The impactVel saves the Velocity as a
%
% For reference, pixel location is as follows.
% (0,0)--→ (0,W)
%  |
%  ↓
% (H,0)

% To save on processing time, this function should be merged with
% calculateVelocity and maxSpread.

% Pre-create the feature matrix in the length of the image_collection
[~,~,~,d] = size(image_collection);
% Preallocate the feautre array, assume minimum of 4 objects.
data=zeros(4,4,d);
for i = 1:d
    %Collect feautres from frame
    s=regionprops(image_collection(:,:,1,i),'Centroid');
    %Determine number of objects
    [objectsNum, ~] = size(s);
        %Save feature data
        for n = 1:objectsNum
            data([1:2],n,i) = s(n).Centroid;
        end
end

% Compute velocity and impact velocity (haven't figured out impact yet).
for i = 1:(d-1)
    for n = 1:4
        %VelocityX 
        data(3,n,i)=data(1,n,i)- data(1,n,i+1);
        %velocityY
        data(4,n,i)=data(2,n,i)-data(2,n,i+1);
    end
end
end
