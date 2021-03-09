function angleMask = drawContactAngles(videosize, contactAngles, contactPos, lineLength)
% videosize is the size of the input video matrix, eg. [512,512,1,418]
%       this should come from second output of video2frame, but that
%       needs to be validated.
% contactAngles is the first output from the contactAngles function
% contactPos is the section output from the contactAngles function
% lineLength can be any number larger than 1
%

%Create Mask Matrix
h = videosize(1); %Video height
w = videosize(2); %Video Width
d = videosize(4); %Video number of frames (depth)
angleMask=false(h,w,1,d);

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
    for n = 1:d
        if any(isnan(contactAngles(:,n)),'all') || any(isnan(contactPos(:,:,n)),'all')
            continue
        end
        
        %Determine reference points to draw between.
        angleX = floor(radius*cosd(contactAngles(side,n)));
        angleY = flipAngle*floor(radius*sind(contactAngles(side,n)));
        %Determine the minimum number of pixels to draw
        if abs(angleX) >= abs(angleY)
            pixels = abs(angleX*2)+1;
        else
            pixels = abs(angleY*2)+1;
        end
        
        %Create Pixel line
        lineX=round(linspace(contactPos(side,1,n)-angleX,contactPos(side,1,n)+angleX,pixels));
        lineY=round(linspace(contactPos(side,2,n)-angleY,contactPos(side,2,n)+angleY,pixels));
        %Remove coordinates outside of angleMask range.
        remove = (lineX > w | lineX <= 0 | lineY > h | lineY <= 0);
        lineX(remove) = [];
        lineY(remove) = [];
        %Print line to tempMask. Then merge into angleMask
        tempMask=false(h,w);
        tempMask(sub2ind([h,w],lineY,lineX))=true;
        angleMask(:,:,1,n)=angleMask(:,:,1,n)|tempMask;       
    end
end
end
