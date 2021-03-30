function [theta, lastFrame, lastFrameNo] = calculateTheta(videoNoNoise)
% This function calculates the angle the video needs to be rotated. It does
% this by measuring the x,y coordinates of the centroid in the first (full
% droplet) frame and the last full droplet frame (frame prior to impact).
% It assumes that the droplet is falling straight down and that the
% difference in x (Delta x) pixels is 0. It uses trigonometry to identify
% the angle of rotation (theta). It also saves the last frame before impact
% and the last frame number. 

%{
% Run this code for a visual representation of what I mean
x = linspace(0, 2/20, 20);
y = sqrt(4 - x.^2);
figure
plot([0, 0.5, 0, 0], [0, 10, 10, 0], '-k',...
    x, y, '-k',...
    0.5, 10, '*r',...
    0, 0, '*r')
xlim([-1, 2])
ylim([-5, 15])
box off
set(gca, 'xtick', [])
set(gca, 'ytick', [])
axis off
set(gca,'visible','off')
text(0.1, 10.5, '\Delta x')
text(0.05, 2.5, '\theta')
text(0.55, 10, 'Centroid first frame')
text(0.05, 0, 'Centroid last frame')
h=text(-0.1,4,'\Delta y');
set(h,'Rotation',90);
text(0.5, 4, '\theta = tan(\Delta x/\Delta y)')
%}

sizeVideo = size(videoNoNoise);  % Find video size
firstFrame = 0;                  % Declares first frame
lastFrame = 0;                   % Declares last frame
lastFrameNo = 0;                 % Declares last frame no
areAllBlack = 0;                 % Loop termination
fillerVariable = 0;              % This acts as a 'continue' statement. Don't know the MATLAB equivalent.

i = 1;
while areAllBlack == 0
    frame = videoNoNoise(:,:,:,i);  % current frame
    if frame(:,:) == 0
        fillerVariable = 1;    % Continues while loop
    else
        firstFrame = frame;    % Designates first frame here
        areAllBlack = 1;       % used to exit loop
    end
    i = i + 1;   % iterates loop
end 


i = i - 1;   % new loop based on the last frame
while lastFrame == 0
    frame = videoNoNoise(:,:,:,i);           % Updates current frame
    if frame(:,:) == 0
        lastFrame = videoNoNoise(:,:,:,i-1); % If nothing is in the frame then the droplet has impacted and was deleted in the last function
        lastFrameNo = i-1;                   % This finds the first all black frame and saves the one before it. 
    end
    i = i + 1;
end

% Find centroids of the first and last frame
regions1 = regionprops(firstFrame);  
regions2 = regionprops(lastFrame);

% Calculate angle (I think there is a degree specific but I just did the
% calculation. 
theta = atan((regions1.Centroid(1)-regions2.Centroid(1))/(regions2.Centroid(2)-regions1.Centroid(2)));
theta = theta * 180 / 3.14159;

end

