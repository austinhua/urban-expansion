close all;
clear all;
%% Read in image
file = '2000.jpg';
original_image = imread(file);
%figure(1);clf;
%imshow(original_image);

%% Get image dimensions
[ m, n, z ] = size(original_image);

%% Highlight borders with pink
color = [ 255 0 225 ];
image = imsharpen(original_image); % sharpen image
image = highlight_edges(image, color); % make edges pink
%figure(2); clf;
%imshow(image);

%% Extract edges
extracted_image = extract_edges(image, color);
figure(3); clf;
imshow(extracted_image);

%% Filter dots out of image
BW = extracted_image(:, :, 1);
filtered_image = remove_dots(BW);
filtered_image = remove_dots(filtered_image);
filtered_image = remove_dots(filtered_image);
figure(4); clf;
imshow(filtered_image);

%% Filter
% filtered_image= im2bw(filtered_image);
% ffta=fft2(filtered_image);
% fftshift1=fftshift(ffta);
% magnitude=abs(fftshift1);
% logMag = log(1 + magnitude);
% figure(10); clf; 
% imshow(logMag, []); 
% title('magnitude');
% 
% imageSizeX = n;
% imageSizeY = m;
% [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% % Next create the circle in the image.
% centerX = double(imageSizeX/2);
% centerY = double(imageSizeY/2);
% radius = 700;
% lpf = (rowsInImage - centerY).^2 ...
%     + (columnsInImage - centerX).^2 <= radius.^2;
% lpf = ~lpf;
% 
% % figure(25);clf;
% % image(logical(lpf));
% % colormap([0;1]);
% % axis square
% % title('Low pass Filter');
% rec = ifft2(lpf.*ffta);
% filtered_image = abs(rec);
% figure(25);clf; imshow(filtered_image);
%% Morphological Operations
rect = strel('rectangle', [ 15 15 ]);
filled_image = imclose(filtered_image, rect);
P = 1000;
CC = bwconncomp(filled_image);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
P = round(biggest*0.8);
filled_image = bwareaopen(filled_image,P);
filled_image = imclose(filled_image, rect);
filled_image = imclose(filled_image, rect);
filled_image= imfill(filled_image,'holes');
filled_image= imfill(filled_image,'holes');
filled_image= imfill(filled_image,'holes');
filled_image = imclose(filled_image, rect);
filled_image = imopen(filled_image, rect);

[B,L] = bwboundaries(filled_image, 'noholes');
figure(30);clf;
imshow(original_image);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
% 
% figure(5); clf;
% imshow(filled_image, []);
