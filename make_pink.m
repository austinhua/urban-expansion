function [ new_image ] = make_pink( image, window )
    image_size = size(image);
    height = image_size(1);
    width = image_size(2);
    new_image = zeros(height, width, 3, 'uint8');
    
    for x = 1:window:height-window
        for y = 1:window:width-window
            mask = zeros(height, width, 3, 'uint8');
            mask(x:x+window, y:y+window, :) = 1;
            mask_image = image.*mask;
            average_image1 = mean(mean(mask_image(x:x+window,y:y+window,1)));
            average_image2 = mean(mean(mask_image(x:x+window,y:y+window,2)));
            average_image3 = mean(mean(mask_image(x:x+window,y:y+window,3)));
            
            if (average_image1 - average_image2) > 100 && (average_image3 - average_image2) > 50
                mask(:,:,1) = (mask(:,:,1) ~= 0).* 255;
                mask(:,:,2) = (mask(:,:,2) ~= 0).* 0;
                mask(:,:,3) = (mask(:,:,3) ~= 0).* 225;
            end
            
            new_image = new_image + mask;
        end
    end
    
    return;
end