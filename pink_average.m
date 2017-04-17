function [ new_image ] = pink_average( image, window )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    
    for x = 1:width
        for y = 1:height
            average = [];
            
            for channel = 1:3
               
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
               
               average(channel) = sum/count;
            end
            
            if (average(1) - average(2)) > 100 && (average(3) - average(2)) > 100
                image(y, x, 1) = 255;
                image(y, x, 2) = 0;
                image(y, x, 3) = 225;
            end
        end
    end
    
    new_image = image;
    return;
end