close all;

file = 'grass_city.jpg';
original_image = imread(file);
% image = imgaussfilt(image, 2);
figure(1);clf;
imshow(original_image);

medianim = medianimage(original_image, 4);
%medianim(:,:,1) = medfilt2(original_image(:,:,1), [5 5]);
%medianim(:,:,2) = medfilt2(original_image(:,:,2), [5 5]);
%medianim(:,:,3) = medfilt2(original_image(:,:,3), [5 5]);
figure(2);clf;
imshow(medianim);

image = imsharpen(original_image);
average_image = average(image, 2);
%figure(2);clf;
%imshow(average_image);

red = image(:,:,1); % red channel
green = image(:,:,2); % green channel
blue = image(:,:,3); % blue channel

image(:,:,1) = imadjust(image(:,:,1));
image(:,:,2) = imadjust(image(:,:,2));
image(:,:,3) = imadjust(image(:,:,3));

image(:,:,1)= histeq(image(:,:,1), 20);
image(:,:,2)= histeq(image(:,:,2), 20);
image(:,:,3)= histeq(image(:,:,3), 20);

image = average(image, 1);

figure(3);clf;
imshow(image);

image = imgaussfilt(image, 1);
hsvImage = rgb2hsv(image);  %# Convert the image to HSV space
hsvImage(:,:,2) = 0.75;           %# Maximize the saturation
%image = hsv2rgb(hsvImage);

%figure(4);clf;
%imshow(image);

zeroes = zeros(size(image, 1), size(image, 2));

%red_only = cat(3, red, green, zeroes);
%green_only = cat(3, zeroes, green, zeroes);
%blue_only = cat(3, zeroes, zeroes, blue);

cform = makecform('srgb2lab');
lab_he = applycform(image, cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

ncolors = 10;
[cluster_idx, cluster_center] = kmeans(ab, ncolors, 'distance', 'sqEuclidean', ...
    'Replicates', 3);
pixel_labels = reshape(cluster_idx, nrows, ncols);
% imshow(pixel_labels, []);

segmented_images = cell(1,ncolors);
rgb_label = repmat(pixel_labels, [1 1 3]);

for k = 1:ncolors
    color = image;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

avg_color=zeros(ncolors, 3);
for k = 1:ncolors
    I_temp = segmented_images{k};
    for i = 1:3
       I_reck=I_temp(:,:,i);
       total = sum(sum(I_reck));
       num=nnz(I_reck);
       avg_color(k,i)=total./num;
    end
%     avg=sum_color/num;
end
grass_base = zeros(ncolors, 3);

grass_base(1:ncolors, 1) = 40;
grass_base(1:ncolors, 2) = 60;
grass_base(1:ncolors, 3) = 50;

avg_color = avg_color-grass_base;
avg_color = avg_color.^2;
dis = 2*avg_color(:,1)+0.5.*avg_color(:,2)+2*avg_color(:,3);
range = max(dis) - min(dis);
threshold = 0.35*range + min(dis);
lol_thres = dis<=threshold;
[m,n,z] = size(image);
grass_comb = zeros(m,n,z,'uint8');
for i =1:ncolors
    if lol_thres(i)
        grass_comb=grass_comb+segmented_images{i};
    end
end
% grass_comb(grass_comb(:,:,1)==0 && grass_comb(:,:,2)==0 && grass_comb(:,:,3)==0)=255; 
figure(20);clf;
imshow(grass_comb)


grass_dirty = grass_comb;
CC = bwconncomp(grass_dirty);
numPixels = cellfun(@numel,CC.PixelIdxList);
largest_obj = max(numPixels);
lolgic = numPixels<0.2*largest_obj;
figure(21);clf;

imshow(grass_dirty);

for i = 1:numel(numPixels)
    if lolgic(i)
%         disp('HOLA')
%         numPixels(CC.PixelIdxList{i}) = 0;  
        
        grass_dirty(CC.PixelIdxList{i}) = 0;
    end
end
% for i
% BW(CC.PixelIdxList{idx}) = 0;

% imshow(grass_dirty);
% CHECK GREEN/BROWN?

grass_dirty(grass_dirty > 0) = 255;
bw_grass = imbinarize(grass_dirty);
grass_dirty=imfill(grass_dirty,8,'holes');
% [idx, C, sumd, D] = kmeans(bw_grass, 4);
figure(21);clf;
imshow(grass_dirty);