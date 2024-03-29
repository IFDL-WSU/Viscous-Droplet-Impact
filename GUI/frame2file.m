function frame2file(videoToBeSaved,fileName,filePath,frameToBeSaved)
% FRAME2FILE Converts a frame from a matrix of frames M into an image file.
%    FRAME2FILE(M,filename, path, frame) converts the selected frame of number "frame" 
%    in matrix M to a file at directory "path". The file will be named "name_#". The file 
%    name must include the extension. For example: Output.jpg 
%
%    Acceptible file formats include all those supported by imwrite(). 
%  
%    See also VIDEO2FRAME, BORDERS, IMWRITE
    
    %Error catching: the uiputfile window was closed. Do nothing.
    if isa(fileName,'double')== 1
        return
    end

    % Split passed name with extension into separate strings.
    splitStr = split(fileName,'.');
    splits = size(splitStr,1);
    newFileName = splitStr(1);
    
    % Error catching, no extension or extra periods in filename.
    if splits == 1      %If only one split, then no extension was provided.
        error("No file extension provided!")
    elseif splits >= 3  %If periods are included in the file name, reconstruct filename.
        for i = 2:(splits-1)
            newFileName=append(newFileName,".",splitStr(i));
        end
    end

    % Convert each matrix entry to to an image and export. The extension
    % will always be the last split string.
    for i = frameToBeSaved
          imwrite(videoToBeSaved(:,:,:,i),append(filePath,"/",newFileName,"_",string(i),".",splitStr(splits)));
    end
end
