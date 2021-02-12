function [data,impactData,droplets] = fallVelocity(image_collection, floorHeight)
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
% The impactVel saves the impact velocity and it's frame as follows:
% impactData = [velocity, frame]
%
% droplets returns the number of ADDITIONAL objects in the image after the
% main droplet.
%
% For reference, pixel location is as follows.
% (0,0)--→ (0,W)
%  |
%  ↓
% (H,0)
%
% To save on processing time, this function should be merged with
% calculateVelocity and maxSpread.

% Pre-create the feature matrix in the length of the image_collection
[~,~,~,d] = size(image_collection);

% Preallocate the feautre array, assume minimum of 4 objects.
data = NaN(4,1,d);
velocity=zeros(1,d);
lower = zeros(1,d);
impact = 0;
maxObjects = 0;

for i = 1:d
    %Collect feautres from frame
    s=regionprops(image_collection(:,:,1,i),'Centroid','BoundingBox');
    %Determine number of objects
    [objectsNum, ~] = size(s);
    if objectsNum == 0
        data([1:2],1,i) = NaN(2,1);
        lower(i) = NaN;
        droplets(i)=0;
        continue
    else
        %Save feature data
        data([1:2],1,i) = s(1).Centroid;
        if objectsNum > 1
            for n = 2:objectsNum
                if n > maxObjects
                    maxObjects = n;
                    data = [data,NaN(4,1,d)];
                end
                data([1:2],n,i) = s(n).Centroid;    
            end
        end
    lower(i) = s(1).BoundingBox(2) + s(1).BoundingBox(4);
    end
    %Buttom most pixel
    droplets(i)=objectsNum-1;
end
impactData(2)= find(lower >= (floorHeight-2), 1, 'first');    

% Compute velocity and impact velocity
for i = 1:(d-1)
    for n = 1:size(data,2)
        %VelocityX 
        data(3,n,i)=data(1,n,i)- data(1,n,i+1);
        %velocityY
        data(4,n,i)=data(2,n,i)-data(2,n,i+1);
        velocity(i) = data(2,1,i)-data(2,1,i+1);
    end
end
    velocityAvg = zeros(d,1);
    for i = 9:d
        velocityAvg(i) = (velocity(i) + ...
            velocity(i-1) + velocity(i-2) +...
            velocity(i-3) + velocity(i-4) +...
            velocity(i-5) + velocity(i-6) +...
            velocity(i-7) + velocity(i-8))/9;
    end
impactData(1) = velocityAvg(impactData(2)); 
 
end

