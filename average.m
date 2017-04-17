function [ new_image ] = average( image, window )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    
    for channel = 1:3
        for x = 1:width
            for y = 1:height
               sum = 0;
               count = 0;
               for i = x-window:x+window
                   for j = y-window:y+window
                       if (i > 0 && i <= width && j > 0 && j <= height)
                           sum = sum + double(image(j, i, channel));
                           count = count + 1;
                       end
                   end
               end
               sum = sum/count;
               image(y, x, channel) = sum;
            end
        end
    end
    
    new_image = image;
    return;
end