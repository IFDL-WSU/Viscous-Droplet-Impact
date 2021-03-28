function [dropletVelocity,impactData,numberOfSatillites] = fallVelocity(videoFloorRemoved, floorHeight)
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
[~,~,~,videoLength] = size(videoFloorRemoved);

% Preallocate the feautre array, assume minimum of 4 objects.
dropletVelocity = NaN(4,1,videoLength);
velocity=zeros(1,videoLength);
lower = zeros(1,videoLength);
impact = 0;
maxObjects = 0;

for frame = 1:videoLength
    %Collect feautres from frame
    s=regionprops(videoFloorRemoved(:,:,1,frame),'Centroid','BoundingBox');
    %Determine number of objects
    [objectsNum, ~] = size(s);
    if objectsNum == 0
        dropletVelocity([1:2],1,frame) = NaN(2,1);
        lower(frame) = NaN;
        numberOfSatillites(frame)=0;
        continue
    else
        %Save feature data
        dropletVelocity([1:2],1,frame) = s(1).Centroid;
        if objectsNum > 1
            for n = 2:objectsNum
                if n > maxObjects
                    maxObjects = n;
                    dropletVelocity = [dropletVelocity,NaN(4,1,videoLength)];
                end
                dropletVelocity([1:2],n,frame) = s(n).Centroid;    
            end
        end
    lower(frame) = s(1).BoundingBox(2) + s(1).BoundingBox(4);
    end
    %Buttom most pixel
    numberOfSatillites(frame)=objectsNum-1;
end
impactData(2)= find(lower >= (floorHeight-2), 1, 'first');    

% Compute velocity and impact velocity
for frame = 1:(videoLength-1)
    for n = 1:size(dropletVelocity,2)
        %VelocityX 
        dropletVelocity(3,n,frame)=dropletVelocity(1,n,frame)- dropletVelocity(1,n,frame+1);
        %velocityY
        dropletVelocity(4,n,frame)=dropletVelocity(2,n,frame)-dropletVelocity(2,n,frame+1);
        velocity(frame) = dropletVelocity(2,1,frame)-dropletVelocity(2,1,frame+1);
    end
end
    velocityAvg = zeros(videoLength,1);
    for frame = 9:videoLength
        velocityAvg(frame) = (velocity(frame) + ...
            velocity(frame-1) + velocity(frame-2) +...
            velocity(frame-3) + velocity(frame-4) +...
            velocity(frame-5) + velocity(frame-6) +...
            velocity(frame-7) + velocity(frame-8))/9;
    end
impactData(1) = velocityAvg(impactData(2)); 
 
end

