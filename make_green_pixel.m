function [ new_image ] = make_green_pixel( image )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    new_image = zeros(height, width, 3, 'uint8');
    
    for x = 1:window:height-window
        for y = 1:window:width-window
            if image(x, y, 2) - image(x, y, 1) > 10 && image(x, y, 2) - image(x, y, 3) > 10
                new_image(x, y, 1) = 0;
                new_image(x, y, 2) = 255;
                new_image(x, y, 3) = 0;
            end
        end
    end
    
    return;
end