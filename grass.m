close all;

file = 'grass_city.jpg';
image = imread(file);
image = imgaussfilt(image);
info = imfinfo(file);
image = imsharpen(image);

red = image(:,:,1); % red channel
green = image(:,:,2); % green channel
blue = image(:,:,3); % blue channel

zeroes = zeros(size(image, 1), size(image, 2));

width = info.Width;
height = info.Height;

red_only = cat(3, red, green, zeroes);
green_only = cat(3, zeroes, green, zeroes);
blue_only = cat(3, zeroes, zeroes, blue);

cform = makecform('srgb2lab');
lab_he = applycform(image, cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

ncolors = 4;
[cluster_idx, cluster_center] = kmeans(ab, ncolors, 'distance', 'sqEuclidean', ...
    'Replicates', 3);
pixel_labels = reshape(cluster_idx, nrows, ncols);
imshow(pixel_labels, []);

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels, [1 1 3]);

for k = 1:ncolors
    color = image;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

imshow(segmented_images{1});
%imshow(image);