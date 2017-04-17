function [ new_image ] = quantize( image, factor )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    %new_image = image;
    
    for channel = 1:3
        for x = 1:width
            for y = 1:height
                value = image(y, x, channel);
                value = value/factor;
                value = floor(value);
                value = value*factor;
                image(y, x, channel) = value;
            end
        end
    end
    
    new_image = image;
    return;
end