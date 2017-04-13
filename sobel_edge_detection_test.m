Irgb = imread('los_angeles.jpg');
figure, imshow(Irgb), title('original image');

%%
I = 0.2989*Irgb(:,:,1)+0.5870*Irgb(:,:,2)+0.1140*Irgb(:,:,3);
figure, imshow(I), title('greyscale image');

% figure
% image(I,'CDataMapping','scaled');
% colormap('gray')
% title('Input Image in Grayscale')

%% Active Contours
%{
mask = zeros(size(I));
mask(25:end-25,25:end-25) = 1;
bw = activecontour(I,mask,300);
figure, imshow(bw), title('Segmented Image')
%}
%%
[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');
%%
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
%%
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');
%%
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');
%%
BWnobord = imclearborder(BWdfill, 4);
figure, imshow(BWnobord), title('cleared border image');
%%
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');
%%
BWoutline = bwperim(BWfinal);
Segout = I; 
Segout(BWoutline) = 255; 
figure, imshow(Segout), title('outlined original image');
