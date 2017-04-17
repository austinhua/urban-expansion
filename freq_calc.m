function [ new_image ] = freq_calc( image_1, window )
    image_size = size(image_1);
    height = image_size(1);
    width = image_size(2);
    new_image = zeros(height, width, 3, 'uint8');
    
    for x = 1:window:height-window
        for y = 1:window:width-window
            mask = zeros(height, width, 3, 'uint8');
            mask(x:x+window, y:y+window, :) = 1;
            mask_image = image_1.*mask;
            Zdft = fftshift(fft2(double(mask_image)));
            figure(40);clf;
            imagesc(abs(Zdft))
            
        end
    end
    
    return;
end