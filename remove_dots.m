function [ new_image ] = remove_dots ( image )
    
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    
    for x = 1:width-1
        for y = 1:height-1
            count = 0;
            for i = x-1:x+1
                for j = y-1:y+1
                    if (i > 0 && i <= width && j > 0 && j <= height && image(y, x) == 255)
                        if image(j, i) == 255
                            count = count + 1;
                        end
                    end
                end
            end
            
            if count == 1
                image(y, x) = 0;
            end
        end
    end
    
    new_image = image;
    
    return;
end