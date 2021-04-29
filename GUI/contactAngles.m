function [contactAngle,contactPoints] = contactAngles(imageFloorRemoved,floorHeight,numberOfPoints,polyOrder)
% This function is HIGHLY dependent on floorremove.m
% This function takes in an image array "image_collection" and a floor
% removal "height" to return the left and right contact angles of the droplet.
% The input "order" sets the order of the polyfit. Defaults to 2
% The input "pNum" sets the number of evaluations points per side. Defaults
% to 10.
%
% The inputs "order" and "pNum" are optional.
%
% [angle[2,:],contactPoints[2,2,:] = contactAngles(image_collection, floorHeight, pNum, order)
%
% angle(1,:) is the right contact angle
% angle(2,:) is the left contact angle
%
% contact[1,:,:] is the right contact point.
% contact[2,:,:] is the left contact point.
% contact[:,1,:] is the x value
% contact[:,2,:] is the y value
%
% Contact Angle values range from 0 to 180 degrees.
% A value of -1 means a angle could not be calculated for that frame.

[~,  ~,  ~,  videoLength] = size(imageFloorRemoved);
% Input error checking, default values, and options
if (exist('polyOrder')==1)
   if polyOrder == 0
       error("Polyfit Order must be greater than 0")
   end
else
   polyOrder = 2; %Default value
end

if (exist('pNum')==1)
    if numberOfPoints <= polyOrder
        error(append("pNum cannot be less than or equal to the order of the polyfit (",string(polyOrder),")"))
    end
    numPoints = numberOfPoints;
else
    numPoints = 10; %Default value
end

for frame=1:videoLength
% Collect image outline

%BWoutline = bwperim(image_collection);
B = bwboundaries(imageFloorRemoved(:,:,:,frame));

%Check if frame is empty (Check that no bodies were found)
if size(B,1) == 0
    contactAngle(1,frame) = NaN;
    contactAngle(2,frame) = NaN;
    contactPoints(1,1:2,frame) = [NaN,NaN];
    contactPoints(2,1:2,frame) = [NaN,NaN];
    clear B J S %Perform next cycle cleanup now.
    continue %skip analysis
end

%Save boundary of important mass 
J = num2cell(cell2mat(B(1,:)),1);
S(:,1) = J{1,1};
S(:,2) = J{1,2};

%Check is frame is not in contact with the floor.
if ~any(S(:,1) >= (floorHeight-1))
    contactAngle(1,frame) = NaN;
    contactAngle(2,frame) = NaN;
    contactPoints(1,1:2,frame) = [NaN,NaN];
    contactPoints(2,1:2,frame) = [NaN,NaN];

    clear B J S %Perform next of cycle cleanup now.
    continue %skip analysis
end
% Collect important Pixels 
index=max(S(:,1)); % Start from bottom.
floor = index;
temp = S(find(S(:,1) == index),2); % Find first points. 
nL = min(temp);
nR = max(temp);
matLoc = [1,1];
L = [[nL; index],zeros(2,numPoints-1)];
R = [[nR; index],zeros(2,numPoints-1)];
Span = index - min(S(:,1));

for i = 0:Span % Move up the image.
    temp = S(find(S(:,1) == index),2);
    if isempty(temp) == 1 % If there is no data at a y value, simply continue to next y value. 
        index = index-1;
        continue
    end
    nL = min(temp); 
    nR = max(temp);
    
    if (nL ~= L(1,matLoc(1))) && (matLoc(1) ~= numPoints)
        matLoc(1)=matLoc(1)+1;
        L(:,matLoc(1)) = [nL;index];
    end
    
    if (nR ~= R(1,matLoc(2))) && (matLoc(2) ~= numPoints)
        matLoc(2)=matLoc(2)+1;
        R(:,matLoc(2)) = [nR;index];
    end
    
    if (matLoc(1) == numPoints) && (matLoc(2) == numPoints)
        break
    end
    index = index-1;
end

% Create PolyNomial Fit
% Set vertical (down image) as x or R(2,:) for future compatibility:
    % Technically, a horizontal value could have multiple vertical
    % values, but not vice-versa. Therefore, the polyfits have been evaluated
    % 90 degrees relative to the image. 
pR = polyfit(R(2,:),R(1,:),polyOrder);
pL = polyfit(L(2,:),L(1,:),polyOrder);

% Collect Floor pixels
    contactPoints(1,1:2,frame) = [polyval(pR,max(R(2,:))),max(R(2,:))];
    contactPoints(2,1:2,frame) = [polyval(pL,max(L(2,:))),max(L(2,:))];

% Create Derivatives and find slope at bottom contact points
qR = polyder(pR); 
qL = polyder(pL);
slopes = [polyval(qR, max(R(2,:))),-polyval(qL, max(L(2,:)))];

% Convert Slopes to contact angles
for i = 1:2
    if slopes(i) < 0
        contactAngle(i,frame)= atand(abs(slopes(i)))+90;
    elseif slopes(i) > 0
        contactAngle(i,frame)= 90-atand(slopes(i));
    elseif slopes(i) == 0
        contactAngle(i,frame)= 90;
    end
end

% % Plot polyfits (REMOVE BEFORE RELEASE. ERROR CHECKING TOOL)
% xR = (min(R(2,:))):0.5:(max(R(2,:)));
% xL = (min(L(2,:))):0.5:(max(L(2,:)));
% yR = polyval(pR, xR);
% yL = polyval(pL, xL);
% imshow(image_collection(:,:,:,n))
% hold on
% plot(yR,xR,'r','LineWidth',2)
% plot(yL,xL,'g','LineWidth',2)
% %plot(R(1,:),R(2,:),'ro')
% %plot(L(1,:),L(2,:),'go')
% hold off

%Necessary. Do not remove.
clear B J S
end
    