function [ bol ] = checkNeighbors( x, y, width, height, color, image )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    bol = 0;
    window = 5; 
    for i = x-window:x+window
        for j = y-window:y+window
           if (i > 0 && i <= width && j > 0 && j <= height)
               if (checkColor(x, y, color, image) == 0)
                   disp('0');
                   return;
               end
           end
        end
    end
    
    bol = 1;
    return;
end

