function converted_Source_Collection = convertSource(image_Collection, floor_Angle)
%% Convert source image to TrueColor image. %%
[a,b,c,d]=size(image_Collection);
converted_Source_Collection = uint8(zeros(a,b,3,d));

if ndims(image_Collection) < 4
    error('Unexpected Source Matrix format. Please provide a grayscale image, an RGB image, or a binary image. ')
elseif islogical(image_Collection) == 1
    for n = 1:3
        converted_Source_Collection(:,:,n,:) = im2uint8(image_Collection(:,:,1,:));
    end
elseif c == 1
    for n = 1:3
        converted_Source_Collection(:,:,n,:) = im2uint8(image_Collection(:,:,1,:));
    end
elseif (c == 3)
    if isa(image_Collection,'uint8') == 0
        converted_Source_Collection(:,:,:,:) = im2uint8(image_Collection(:,:,:,:));
    end
else
    error('Unexpected Source Matrix format. Please provide a grayscale image, an RGB image, or a binary image. ')
end

%% Rotate TrueColor Image to match rotated borders.
if floor_Angle ~= 0
    for i = 1:d
        converted_Source_Collection(:,:,:,i) = ...
        imrotate(converted_Source_Collection(:,:,:,i),floor_Angle,'bilinear', 'crop');
    end
end
end