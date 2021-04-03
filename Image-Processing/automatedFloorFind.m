function [calculatedFloor] = automatedFloorFind(fileName)
%{ 
  These are the steps needed to use the automated floor. I put them all in a function for easy to read but the function is not necessary.
  %}
    videoSource = video2frame(fileName);  % uploads the video
    videoBorders = borders(videoSource);  % converts to borders
    videoNoNoise = removeNoise(videoBorders);  % removes some noise
    [theta, lastFrame, lastFrameNo] = calculateTheta(videoNoNoise);  % finds the angle, last frame before impact, and the frame no
    videoRotated = rotateVideo(videoBorders, theta);  % rotates the video
    calculatedFloor = calculateFloor(lastFrame, lastFrameNo, videoRotated);  % Calculates the floor height (pixel)
    videoCalculatedFloorRemoved = removeCalculatedFloor(videoRotated, calculatedFloor, lastFrameNo);  % Removes the floor
    imshow([videoCalculatedFloorRemoved(:,:,:,lastFrameNo), videoCalculatedFloorRemoved(:,:,:,lastFrameNo+10)]) % shows the last frame and the impact frame
end
