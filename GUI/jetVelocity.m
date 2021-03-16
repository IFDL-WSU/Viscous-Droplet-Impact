function [jetVel,jetPos,jetDia]=jetVelocity(image_collection)
% This function finds the jet velocity, position, and diameter using a
% black and white border matrix.

[~,  ~,  ~,  d] = size(image_collection);

%Preallocate Matrices
jetPos = NaN(d,1);
jetDia = NaN(d,1);
jetVel = NaN(d,1);

for n = 1:d %For each frame.
    %Find the boundary points of the droplet.
    B = bwboundaries(image_collection(:,:,:,n));
    %Check if frame is empty (Check that no bodies were found)
    if size(B,1) == 0
        jetPos(n) = NaN;
        jetDia(n) = NaN;
        clear B J S %Perform next cycle cleanup now.
        continue %skip analysis
    end
    
    %Save boundary of important mass
    J = num2cell(cell2mat(B(1,:)),1);
    S(:,1) = J{1,1};
    S(:,2) = J{1,2};
    
    %Find points to compute width
    jetPos(n) = min(S(:,1)); % Start from top
    dropletBottom = max(S(:,1)); %Stop at bottom.
    
    %Find down the droplet
    i = 1;
    width = zeros((dropletBottom)-jetPos(n),1); %Preallocate width
    for index = jetPos(n):dropletBottom
        %Add a way to autodetect if bottom of droplet is reached.
        points = S((S(:,1) == index),2); % Find widest points for each level
        width(i)= max(points)-min(points);
        i=i+1;
    end
    
    %Find local maximum for example/program
    TF = islocalmax(width);
    I_localMax = find(TF,1,'first');
    if I_localMax ~= 0 %If there is a local maximum
        jetDia(n) = width(I_localMax); %Use local max diameter.
    else
        jetDia(n) = mean(width(1:ceil(0.1*i))); %average top ten percent
    end
    
    %Necessary. Do not remove.
    clear B J S
end

for i = 2:d
        %jetVel in Y 
        jetVel(i)=jetPos(i)-jetPos(i-1);
end
jetVel(1)=NaN;

% plot(S(:,2),S(:,1))
% hold on
% yline(top+I_Max,'r')
% if I_localMax ~= 0
%     yline(top+I_localMax,'b')
% end
% set(gca, 'YDir','reverse')
% hold off