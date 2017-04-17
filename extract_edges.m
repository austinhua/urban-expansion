function [ new_image ] = extract_edges( image, color )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    new_image = zeros(height, width, 3, 'uint8');
    
    for x = 1:width
        for y = 1:height
            if image(y, x, 1) == color(1) && image(y, x, 2) == color(2) && image(y, x, 3) == color(3)
                new_image(y,x,1) = 255;
                new_image(y,x,2) = 255;
                new_image(y,x,3) = 255;
            end
        end
    end
    
    return;
end