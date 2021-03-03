function overlay_Collection = maskOverlay(converted_Source_Collection,mask_Collection,line_Thickness,line_Color)
%Check for size error
[ a, b, ~, d] = size(converted_Source_Collection);
[oa,ob, ~,od] = size(mask_Collection);
if (a ~= oa) || (b ~= ob) || (d ~= od)
    error('Source and Overlay matrix sizes do not match!')
end

%Set Overlay Thickness
if (exist('line_Thickness','var'))  %Read in provided thickness
    
else
    line_Thickness = 1;       %Default to 1.
end

%Set Overlay Color
if (exist('line_Color','var'))  %Read in provided color
    colorDef = line_Color;
else
    colorDef = [255,0,0];       %Default to red.
end

%Thicken overlay mask.
SE = strel('diamond',(line_Thickness-1)/2);
Mask(:,:,1,:) = imdilate((mask_Collection),SE);

%Set overlay color onto image using mask.;
false_Mask = false(a,b,3,d); 
overlay_Collection = converted_Source_Collection;
for n = 1:3
    color_Mask = false_Mask;
    color_Mask(:,:,n,:) = Mask;
    overlay_Collection(color_Mask)=colorDef(n);
end
    
    
