close all;
clear all;
% file = 'frequency_test.jpg';
% original_image = imread(file);
% [ m, n, z ] = size(original_image);
% 
% figure(1);clf;
% imshow(original_image);
% fftA = fft2(double(original_image));
% figure, imshow(abs(fftshift(fftA))*1000,[24 100000]), colormap gray
% title('Image A FFT2 Magnitude')
% figure, imshow(angle(fftshift(fftA)),[-pi pi]), colormap gray
% title('Image A FFT2 Phase')

a = imread('boundarypink.jpg');
figure(1);clf;
imshow(a);

dim_a = size(a);
figure,imshow(a);
ffta=fft2(a);
fftshift1=fftshift(ffta);
magnitude=abs(fftshift1);
logMag = log(1 + magnitude); %// New
for c = 1 : size(a,3); %// New - normalize each plane
    logMag(:,:,c) = mat2gray(logMag(:,:,c));
end
figure(1);clf; imshow(logMag); title('magnitude');
% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
imageSizeX = dim_a(2);
imageSizeY = dim_a(1);
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = double(dim_a(2)/2);
centerY = double(dim_a(1)/2);
radius = 150;
lpf_temp = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
lpf(:,:,1) = lpf_temp;
lpf(:,:,2) = lpf_temp;
lpf(:,:,3) = lpf_temp;
% lpf = double(lpf)
% circlePixels is a 2D "logical" array.
% Now, display it.
figure(2);clf;
image(lpf);
colormap([0 0 0; 1 1 1]);
axis square
title('Low pass Filter');
rec = ifft2(lpf.*ffta);
rec_abs = abs(rec);
figure(3);clf;
imshow(rec_abs);

Kmedian = medfilt2(rgb2gray(rec_abs));
figure(7);clf;
Kmedian = medfilt2(Kmedian);
Kmedian = medfilt2(Kmedian);
Kmedian = medfilt2(Kmedian);

Kmedian = floor(Kmedian);
Kmedian = imfill(Kmedian,4, 'holes');


Kmedian = imcomplement(Kmedian);
Kmedian = imfill(Kmedian, 'holes');

figure(30);clf;
per =bwperim(Kmedian);
title('Filtered Noise')
imshow(Kmedian)

edg_can = edge(Kmedian, 'Canny');

figure(20);clf;
imshow(per);

figure(21);clf;
imshow(edg_can);

Interp=a;
for k=1:5
    Interp=imopen(edg_can, strel('disk',20));
end

BW = bwmorph(bwconvhull(edg_can), 'erode', 5);
Mask=repmat(BW, [1,1,3]);

Interpolated(:,:)= medfilt2(Interp.*~(BW==edg_can), [4 4]);

% Kmedian = imdilate(Kmedian,strel('disk',0.5));
% Kmedian = bwmorph(Kmedian,'thin',inf);
%Kper_2 = imopen(per,strel('disk',3));
% Ifilt = imfilter(
%figure(50);clf;
%imshow(Kper_2)
%title('Smooth')
% contour = bwtraceboundary(Kmedian, [randi(dim_a(1)) randi(dim_a(2))],'W', 8, Inf);

% 
% hold on 
% plot(contour(:,2),contour(:,1),'g','LineWidth',2);
% boxKernel = ones(21,21); % Or whatever size window you want.
% blurredImage = conv2(ffta, boxKernel, 'same');

% image_1 = imsharpen(original_image);
% imagesc(rgb2gray(image_1))
% image_1 = rgb2gray(double(image_1));
% subImage = image_1(600:800, 600:800);
% figure(2);clf;
% imagesc(subImage)
% % image_1 = freq_calc(image_1, 100);
% % I = rgb2gray(double(image_1));
% Zdft = fftshift(fft2(image_1));
% figure(40);clf;
% A = abs(Zdft);
% % imagesc((A))