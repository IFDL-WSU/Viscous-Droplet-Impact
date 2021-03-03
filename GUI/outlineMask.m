function mask_Collection = outlineMask(borders_Image_Collection)
    mask_Collection = logical(bwperim(borders_Image_Collection,8));
end