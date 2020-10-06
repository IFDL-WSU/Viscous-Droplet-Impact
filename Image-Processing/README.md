# Image-Processing
This section of the project revolves arround making and understanding the functions for Image-Processing in matlab. 

---

## Table of Contents
1. [Goals](#goals)
2. [Function Instructions](#functions)
3. [File Manifest](#manifest)
4. [Dependencies](#dependencies)
5. [Known Bugs](#bugs)
6. [Changelog](#log)

---
## Goals <a name="goals"></a>
  By 10/03/2020: Function that takes video input and outputs frame-by-frame  <br /> 
  By 10/10/2020: Function that processes frames and outputs frames with boundary layers  <br /> 
  By 10/17/2020: Overlay axes and create a function that outputs center of gravity for boundary layer images  <br /> 
  By 10/24/2020: Function that takes center of gravity, axis, and boundary layer input and outputs velocity and max spread radius <br /> 
  By 11/14/2020: Final app that takes video file input and outputs video frame-by-frame with boundary outlined along with velocity, max spread radius, jet formation, droplet break-up, and partial rebound data

---
## Function Instructions <a name="functions"></a>
video2frame Converts a greyscale video file to a matrix of greyscale frames.
   [M,R] = video2frame('MEDIA.avi') converts MEDIA.avi to 4D
   matrix M of frames, and reports the number of frames R.

frame2file Converts and saves a greyscale matrix of video frames into indivigual image files to a location of your choosing.
   FRAME2FILE(M,filename, path, ext).
	M is the greyscale image matrix (4 dimensional Matrix).
	filename is the enumerated image files prefix (string)
	path is the file path to the desired output folder (string)
	ext is the desired file format. All formats supported by imwrite() are supported here.
		Types include: 'jpg', 'jp2', 'bmp', 'tif', 'png', etc.
	

An indivigual frame can be shown using:
   imshow( M( : , : , : , frame) )
 
---
## File Manifest <a name="manifest"></a>
  video2frame.m
  frame2file.m
  borders.m

---
## Dependencies <a name="dependencies"></a>
The following packages are required for this applet to function properly: <br /> 
"MATLAB"

## Known Bugs <a name="bugs"></a>

---

## Changelog <a name="log"></a>
10/01/2020 - Update /Image-Processing/README.md
10/03/2020 - Created video2frame.m
	   - updated README.md
10/05/2020 - Created first draft of borders.m
	   - Created frame2file.m
10/06/2020 - Updated README.md
