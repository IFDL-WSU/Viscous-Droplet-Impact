function maskOutline = outlineMask(videoFloorRemoved)
    maskOutline = logical(bwperim(videoFloorRemoved,8));
end