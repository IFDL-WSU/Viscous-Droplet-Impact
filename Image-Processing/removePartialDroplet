function [X] = removePartialDroplet(dat)
%{
This function removes the first frames of a droplet video. This is because
the first frames have partial droplets. These partial droplets provide no
useful data and need to be removed. 

At this point, the floorremove() should have created all black frames when
the droplet is partially there. This function finds the last frame with
only black. Then creates a new 4-D array (dataset) starting on the first
full droplet.

dat ~ the dataset with the droplet frames.
frame ~ variable to record the last frame that is all black.
%}
[a,b,c,d] = size(dat);

frame = 0;
for i = 1:d
    if dat(:,:,:,i) == 0
        frame = i;
    end
end 
X = dat(:,:,:,frame+1:end);

% Find if its all black. Add an break once it sees a droplet.
end
