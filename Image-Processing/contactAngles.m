function [R_angle,L_angle] = contactAngles(image_collection, floorHeight)
% This function is HIGHLY dependent on floorremove.m
% This function takes in an image array "image_collection" and a floor
% removal height to return the left and right contact angles.
%
% [R_angle, L_Angle] = contactAngles(image_collection, floorHeight)

[~,  ~,  ~,  d] = size(image_collection);
for n=1:d
%% Collect image outline

%BWoutline = bwperim(image_collection);
B = bwboundaries(image_collection(:,:,:,n));
%Save boundary of important mass 
J = num2cell(cell2mat(B(1,:)),1);
S(:,1) = J{1,1};
S(:,2) = J{1,2};

%% Collect important Pixels 
index=max(S(:,1)); % Start from bottom.
floor = index;
numPoints = 6; % Collect 6 points
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

%% Create Splines
    ppR = spline(R(2,:),R(1,:));
    ppL = spline(L(2,:),L(1,:));
    %Create Derivatives
    [breaksR,coefsR,lR,kR,dR] = unmkpp(ppR);
    [breaksL,coefsL,lL,kL,dL] = unmkpp(ppL);
    ppR2 = mkpp(breaksR,repmat(kR-1:-1:1,dR*lR,1).*coefsR(:,1:kR-1),dR);
    ppL2 = mkpp(breaksL,repmat(kL-1:-1:1,dL*lL,1).*coefsL(:,1:kL-1),dL);
    %Evaluate Angles
    R_angle(n)= atand(inv(ppval(ppR2,floor)));
    L_angle(n)= -atand(inv(ppval(ppL2,floor)));
    
%% Angle post processing??
    if R_angle(n) < 0
        R_angle(n) = R_angle(n) + 180;
    end
    if L_angle < 0
        L_angle(n) = L_angle(n) + 180;
    end
        
clear B J S ppR ppL ppR2 ppl2
end
    