close all;

file = '2000.jpg';
%file = 'lasvegas.jpg';

original_image = imread(file);
[ m, n, z ] = size(original_image);

figure(1);clf;
imshow(original_image);

%image = make_green(image, 1);
%image = make_green_pixel(image);

image = imsharpen(original_image);
%image = highlight_edges(image);
figure(2); clf;
imshow(image);

BW = rgb2gray(image);
BW = imfill(BW, 'holes');
figure(3); clf;
imshow(BW);

%extracted_image = extract_pink(image);
%figure(4); clf;
%imshow(extracted_image);

%modeimage = modereplacement(image, 5);
%modeimage = quantize(image, 100);
%figure(3); clf;
%imshow(modeimage);

%[image_no_dither, map] = rgb2ind(image, 32, 'nodither');
%figure(3); clf;
%imshow(image_no_dither, map);

red = image(:,:,1); % red channel
green = image(:,:,2); % green channel
blue = image(:,:,3); % blue channel

image(:,:,1) = imadjust(image(:,:,1));
image(:,:,2) = imadjust(image(:,:,2));
image(:,:,3) = imadjust(image(:,:,3));

% image(:,:,1)= histeq(image(:,:,1), 20);
% image(:,:,2)= histeq(image(:,:,2), 20);
% image(:,:,3)= histeq(image(:,:,3), 20);

green_thres = 5;
green_min = 30;

ratio = 0;

for x = 1:m
    for y = 1:n
        r_val = image(x,y,1);
        g_val = image(x,y,2);
        b_val = image(x,y,3);
        
        if(g_val-r_val > green_thres && g_val-b_val > green_thres && g_val < green_min)
            g_val = g_val + 50;
            r_val = r_val-green_min;
            b_val = b_val-green_min;
            %g_val = 255;
            %r_val = 0;
            %b_val = 0;
            image(x,y,1) = r_val;
            image(x,y,2) = g_val;
            image(x,y,3) = b_val;
            ratio = ratio + 1;
        end
    end
end

ratio = 10*ratio/m/n;

%%figure(3);clf;
%%imshow(image);

%image = average(image, 2);
image = imgaussfilt(image, 1);
figure(4);clf;
imshow(image);

%%hsvImage(:,:,2) = 0.75;           %# Maximize the saturation
%image = hsv2rgb(hsvImage);

%figure(4);clf;
%imshow(image);

%zeroes = zeros(size(image, 1), size(image, 2));

%red_only = cat(3, red, green, zeroes);
%green_only = cat(3, zeroes, green, zeroes);
%blue_only = cat(3, zeroes, zeroes, blue);

cform = makecform('srgb2lab');
lab_he = applycform(image, cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

ncolors = 7;
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

% avg_color = avg_color-grass_base;
% avg_color = avg_color.^2;

scale = 50;
dis = scale./(abs(avg_color(:,1)-avg_color(:,2))+1)+scale./(abs(avg_color(:,3)-avg_color(:,2))+1)+scale*(abs(avg_color(:,1)-avg_color(:,3)));
range = max(dis) - min(dis);
threshold = 0.25*range + min(dis);
lol_thres = dis<=threshold;
[m,n,z] = size(image);
grass_comb = zeros(m,n,z,'uint8');

for i =1:ncolors
    if lol_thres(i)
        if avg_color(i,2)>avg_color(i,3) && avg_color(i,2)>avg_color(i,1)
            grass_comb=grass_comb+segmented_images{i};
        else
            lol_thres(i) = 0;
        end
    end
end
% grass_comb(grass_comb(:,:,1)==0 && grass_comb(:,:,2)==0 && grass_comb(:,:,3)==0)=255; 
figure(5);clf;
imshow(grass_comb)

grass_dirty = grass_comb;
grass_dirty=imfill(grass_dirty,8,'holes');
CC = bwconncomp(grass_dirty);
numPixels = cellfun(@numel,CC.PixelIdxList);
largest_obj = max(numPixels);
lolgic = numPixels<0.05*largest_obj;
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
% bw_grass = imbinarize(grass_dirty);
% [idx, C, sumd, D] = kmeans(bw_grass, 4);
figure(21);clf;
imshow(grass_dirty);