function frame2file(M,name,path,ext,frame)
% FRAME2FILE Converts a matrix of frames M into a series of pictures of an file type.
%    FRAME2FILE(M,filename, path, ext, frame) converts the selected frame of number "frame" 
%    in matrix M to a file at directory "path" of the format specified by "ext". 
%
%    Acceptible file formats include all those supported by imwrite(). 
%  
%    See also VIDEO2FRAME, BORDERS, IMWRITE

    [~,~,~,fRange] = size(M); %Number of frames.
    % Convert each matrix entry to to an image and export.
          imwrite(M(:,:,:,frame),append(path,"/", name, string(frame), ".", ext));
end
