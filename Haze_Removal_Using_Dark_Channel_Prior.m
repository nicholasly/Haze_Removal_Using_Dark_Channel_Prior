clear;
close all;
image = imread('01.png');
image = double(image);
image = image ./ 255;
dark = multiscale_dark_channel(image);

[m, n, ~] = size(image);
image_size = m * n;
chosen_size = floor(image_size / 1000);
DarkVec = reshape(dark, image_size, 1);
ImageVec = reshape(image, image_size, 3);

[DarkVec, indices] = sort(DarkVec);
indices = indices(image_size - chosen_size + 1:end);

A_sum = zeros(1,3);
for i = 1:chosen_size
    A_sum = A_sum + ImageVec(indices(i),:);
end

A = A_sum / chosen_size;

omega = 0.95;
im = zeros(size(image));

for i = 1:3
    im(:,:,i) = image(:,:,i) ./ A(i);
end

dark_1 = multiscale_dark_channel(im);
t = 1 - omega * dark_1;


J = image;
t0 = 0.1;
for i = 1:m
    for j = 1:n
        for k = 1:3
            J(i,j,k) = (image(i,j,k) - A(k)) / max(t(i,j),t0) + A(k);
        end
    end
end

hsv = rgb2hsv(J);
H = hsv(:,:,1); 
S = hsv(:,:,2); 
V = hsv(:,:,3);

for i = 1:m
    for j = 1: n 
        hsv(i,j,3) = 1.2 * hsv(i,j,3);
    end 
end

J = hsv2rgb(hsv);
imwrite(J, 'dehaze.png');
