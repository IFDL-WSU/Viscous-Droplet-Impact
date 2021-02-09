function angle = contactAngles(image_collection,floorHeight,pNum,order)
% This function is HIGHLY dependent on floorremove.m
% This function takes in an image array "image_collection" and a floor
% removal "height" to return the left and right contact angles of the droplet.
% The input "order" sets the order of the polyfit. Defaults to 2
% The input "pNum" sets the number of evaluations points per side. Defaults
% to 10.
%
% The inputs "order" and "pNum" are optional.
%
% angle[2,:] = contactAngles(image_collection, floorHeight, pNum, order)
%
% angle(1,:) is the right contact angle
% angle(2,:) is the left contact angle
%
% Contact Angle values range from 0 to 180 degrees.
% A value of -1 means a angle could not be calculated for that frame.

[~,  ~,  ~,  d] = size(image_collection);
for n=1:d
%% Collect image outline

%BWoutline = bwperim(image_collection);
B = bwboundaries(image_collection(:,:,:,n));

%Check if frame is empty (Check that no bodies were found)
if size(B,1) == 0
    angle(1,n) = -1;
    angle(2,n) = -1;
    clear B J S %Perform next of cycle cleanup now.
    continue %skip analysis
end

%Save boundary of important mass 
J = num2cell(cell2mat(B(1,:)),1);
S(:,1) = J{1,1};
S(:,2) = J{1,2};

%Check is frame is not in contact with the floor.
if ~any(S(:,1) >= (floorHeight-1))
    angle(1,n) = -1;
    angle(2,n) = -1;
    clear B J S %Perform next of cycle cleanup now.
    continue %skip analysis
end
%% Collect important Pixels 
if (exist('pNum')) == 1
    numPoints = pNum;
else
    numPoints = 10;
end

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

%% Create PolyNomial Fit
% Create a poly fit of "order" degree using the points collected before
if (exist('order')) == 1
    degree = order;
else
    degree = 2; %Default to a order of 2.
end
% Set vertical (down image) as x or R(2,:) for future compatibility:
    % Technically, a horizontal value could have multiple vertical
    % values, but not vice-versa. Therefore, the polyfits have been evaluated
    % 90 degrees relative to the image. 
[pR,sR] = polyfit(R(2,:),R(1,:),degree);
[pL,sL] = polyfit(L(2,:),L(1,:),degree);

% Create Derivatives and find slope at bottom contact points
qR = polyder(pR); 
qL = polyder(pL);
slopes = [polyval(qR, max(R(2,:))),-polyval(qL, max(L(2,:)))];
    
% Convert Slopes to contact angles
for i = 1:2
    if slopes(i) < 0
        angle(i,n)= atand(abs(slopes(i)))+90;
    elseif slopes(i) > 0
        angle(i,n)= 90-atand(slopes(i));
    elseif slopes(i) == 0
        angle(i,n)= 90;
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
    