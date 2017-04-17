function [ bol ] = checkColor( x, y, color, image )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% color =
% | 1 2 3 |
% | lower |
% | upper |

    bol = 1;
    count = 0;
    for i = 1:3
        if (image(y,x,i) < color(1, i) && image(y,x,i) > color(2, i))
            count = count + 1;
        end
    end
    
    if count < 3
        bol = 0;
    end
    
    return;
end

