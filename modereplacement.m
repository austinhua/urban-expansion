function [ new_image ] = modereplacement( image, window )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    %new_image = image;
    
    for channel = 1:3
        for x = 1:1
            for y = 1:1
               vector = [];
               for i = x:x+window
                   for j = y:y+window
                       if ( i <= width && j <= height) 
                           vector = [ vector image(j, i, channel) ];
                       end
                   end
               end
               disp(vector);
               mode_val = mode(vector);
               image(y, x, channel) = mode_val;
               for i = x:x+window
                   for j = y:y+window
                       if ( i <= width && j <= height) 
                           image(j, i, channel) = mode_val;
                       end
                   end
               end
               
               x = x + window;
               y = y + window;
            end
        end
    end
    
    new_image = image;
    return;
end