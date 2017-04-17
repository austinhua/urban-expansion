close all;

%% Read in image
file = 'boundary.jpg';
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

%% Morphological Operations
rect = strel('rectangle', [ 15 15 ]);
filled_image = imclose(filtered_image, rect);
filled_image = imclose(filled_image, rect);
filled_image = imclose(filled_image, rect);
figure(5); clf;
imshow(filled_image, []);
