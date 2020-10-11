function M=floorremove(M,h,t,w)
%This is a demonstration function. This function will be integrated into
%borders.m as it is an intermediary step

%h is the height at the center of the frame,
%t is the tilt of the line.
%w is the line width

[a,  b,  c,  d] = size(M);
%H * W * 1 * F
% (0,0)--> (0,W)
%   |
%   ˇ
% (H,0)

f=@(x) t*-(x-(b/2))+(a-h);
    for n=(1:b)                 %This is our function's x variable        
        if fix(f(n)) >= a       %If the line goes off the bottom of the screen
            y = a;
        elseif fix(f(n)) <= 0   %If the line goes off top of screen.
            y = 1;
        else
            y = fix(f(n));      
        end
                                
        for m=(y:a)             %Overwrite all pixels below the curve in each column
                %Create a white line 3 pixels thick
                M(m,n,1,1)=((m-y)<w);   %False is black, true is white.
        end
    end
end