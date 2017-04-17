function [ new_image ] = highlight_edges ( image, color )
    
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    
    threshold = 80;
    
    for x = 1:width-1
        for y = 1:height-1
            distance = 0;
            
            for channel = 1:3
               difference1 = abs(double(image(y, x, channel)) - double(image(y+1, x, channel)));
               difference2 = abs(double(image(y, x, channel)) - double(image(y, x+1, channel)));
               difference3 = abs(double(image(y, x, channel)) - double(image(y+1, x+1, channel)));
               
               difference = max([ difference1; difference2; difference3]);
               difference_squared = difference^2;
               
               if (channel == 2)
                   difference_squared = difference_squared*10;
               end
               
               distance = distance + difference_squared;
               distance = distance^0.5;
            end
            
            if (distance > threshold)
                image(y, x, 1) = color(1);
                image(y, x, 2) = color(2);
                image(y, x, 3) = color(3);
            end
        end
    end
    
    new_image = image;
    return;
end