function maskAngles = drawContactAngles(videoSize, contactAngle, contactPoints, lineLength)
% videosize is the size of the input video matrix, eg. [512,512,1,418]
%       this should come from second output of video2frame, but that
%       needs to be validated.
% contactAngles is the first output from the contactAngles function
% contactPos is the section output from the contactAngles function
% lineLength can be any number larger than 1
%

%Create Mask Matrix
videoHeight = videoSize(1); %Video height
videoWidth = videoSize(2); %Video Width
videoLength = videoSize(4); %Video number of frames (depth)
maskAngles=false(videoHeight,videoWidth,1,videoLength);

radius = ceil(lineLength/2)-1;

%Draw contact angles for each frame, right then left side.
%(Do all one side first for faster computation.)
for side = 1:2
    switch side %Flip the contact angles based on the side
        case 1
            flipAngle = 1;
        case 2
            flipAngle = -1;
    end
    %Draw the contact angle for each frame.
    for frame = 1:videoLength
        if any(isnan(contactAngle(:,frame)),'all') || any(isnan(contactPoints(:,:,frame)),'all')
            continue
        end
        
        %Determine reference points to draw between.
        angleX = floor(radius*cosd(contactAngle(side,frame)));
        angleY = flipAngle*floor(radius*sind(contactAngle(side,frame)));
        %Determine the minimum number of pixels to draw
        if abs(angleX) >= abs(angleY)
            pixels = abs(angleX*2)+1;
        else
            pixels = abs(angleY*2)+1;
        end
        
        %Create Pixel line
        lineX=round(linspace(contactPoints(side,1,frame)-angleX,contactPoints(side,1,frame)+angleX,pixels));
        lineY=round(linspace(contactPoints(side,2,frame)-angleY,contactPoints(side,2,frame)+angleY,pixels));
        %Remove coordinates outside of angleMask range.
        remove = (lineX > videoWidth | lineX <= 0 | lineY > videoHeight | lineY <= 0);
        lineX(remove) = [];
        lineY(remove) = [];
        %Print line to tempMask. Then merge into angleMask
        tempMask=false(videoHeight,videoWidth);
        tempMask(sub2ind([videoHeight,videoWidth],lineY,lineX))=true;
        maskAngles(:,:,1,frame)=maskAngles(:,:,1,frame)|tempMask;       
    end
end
end
