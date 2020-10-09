function B=floorremove(M,h,t)

%h is the height at the center of the frame,
%t is the tilt of the line.

[a,  b,  c,  d] = size(M);
%H * W * 1 * F
% (0,0)--> (0,W)
%   |
%   ˇ
% (H,0)

f=@(x) t*-(x-(b/2))+(a-h);

for i=1:1                       %Until this is ready to deploy on multiple frames, i=1=1
                                    %This saves some time during initial
                                    %testing.
    for n=(1:b)                 %This is our function's x variable
        
        if fix(f(n)) >= a       %If the line goes off the bottom of the screen
            y = a;
        elseif fix(f(n)) <= 0   %If the line goes off top of screen.
            y = 1;
        else
            y = fix(f(n));      
        end
                                %Overwrite all pixels
        for m=(y:a)
            M(m,n,1,i)=false;   %False is black, true is white
        end
    end
end

%Return cells
B=M;

%Temporary inclusion for faster testing.
imshow(B(:,:,:,1))
end