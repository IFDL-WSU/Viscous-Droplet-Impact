function M = outlines(sourceM, overlayM, rotation_angle, thickness, color)
% Outlines overlays the outline given by an image overlayM overtop of a
% source image sourceM.
%
% M = outlines(sourceM, overlayM, rotation_angle)
%   Returns an TrueColor image matrix M with a red pixel border. The inputs are as follows:
%
% 'sourceM' may either be a truecolor image matrix, a BW image, or a grayscale image.
%
% 'overlayM' must be a logical processed black and white region image matrix.
%
% 'rotation_angle' is the amount the border image was rotated in degrees
% during processing. Use the same value from floorremoval.m
%
% 'thickness' is the line thickness of the outline. Minimum is 1.
%
% NOTE: sourceM and overlayM must have the same number of frames and have
% equal sizes!
% 
% M = outlines(sourceM, overlayM, rotation_angle, color)
%   Returns an TrueColor image matrix M with a chosen color border.
%   The additional inputs are as follows:
%
%   'color' is an RGB color given by 1x3 array. Each color component may
%   range from 0 to 255. [R,G,B] 
%        Ex: [ 0 ,255, 0 ] is green
%            [255, 0 ,255] is purple    

%% Convert source image to TrueColor image. %%
% I chose double rather than uint16 for better color accuracy.

[ a, b, c, d] = size(sourceM);
[oa,ob, ~,od] = size(overlayM);

if (a ~= oa) || (b ~= ob) || (d ~= od)
    error('Source and Overlay matrix sizes do not match!')
end

if ndims(sourceM) < 4
    error('Unexpected Source Matrix format. Please provide a grayscale image, an RGB truecolor image, or a binary image. ')
elseif islogical(sourceM) == 1
    for i = 1:d
        for n = 1:3
            M(:,:,n,i) = double(sourceM(:,:,1,i));
        end
    end
elseif c == 1
    for i = 1:d
        for n = 1:3
            M(:,:,n,i) = double(sourceM(:,:,1,i))./255; 
        end
    end
elseif (c == 3)
    if isa(sourceM,'uint8') == 1
        M(:,:,:,:) = double(sourceM(:,:,:,:))./255;
    elseif isa(sourceM,'uint16') == 1
        M(:,:,:,:) = double(sourceM(:,:,:,:))./65535;
    end 
else
    error('Unexpected Source Matrix format. Please provide a grayscale image, an RGB truecolor image, or a binary image. ')
end
%% Rotate TrueColor Image to match rotated borders.
    for i = 1:d
        M(:,:,:,i) = imrotate(M(:,:,:,i),...
            rotation_angle,...
            'bilinear', 'crop');
    end


%% Create outline matrix from overlayM %%
if (exist('color')) == 1
    colorDef = color;
else
    colorDef = [255,0,0];
end

SE = strel('diamond',(thickness-1)/2);
for i =1:d
    % Create outline, clear the boundary pixels in source image.
    outline(:,:,1,i) = bwperim(overlayM(:,:,1,i),8);
    outline(:,:,1,i) = imdilate(outline(:,:,1,i),SE);
    for n=1:3
        M(:,:,n,i) = M(:,:,n,i).*~outline(:,:,1,i);
        M(:,:,n,i) = M(:,:,n,i) + (outline(:,:,1,i)*colorDef(n));
    end
    
end
end
