function [ new_image ] = medianimage( image, window )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    %new_image = image;
    
    for channel = 1:3
        for x = 1:width
            for y = 1:height
               vector = [];
               for i = x-window:x+window
                   for j = y-window:y+window
                       if (i > 0 && i <= width && j > 0 && j <= height)
                           vector = [ vector image(y, x, channel) ];
                       end
                   end
               end
               median_val = median(vector);
               mode_val = mode(vector);
               image(y, x, channel) = mode_val;
               %for i = x-window:x+window
                   %for j = y-window:y+window
                       %if (i > 0 && i <= width && j > 0 && j <= height)
                           %image(j, i, channel) = mode_val;
                       %end
                   %end
               %end
            end
        end
    end
    
    new_image = image;
    return;
end