I = imread('hazy.png');
[m,n,k] = size(I); 
I_semi = zeros(m, n, k);
h = zeros(m, n);
r_h = zeros(m, n);
t_h = 0.5;
%%
for i = 1:m
    for j = 1:n
        for k = 1:3
            I_semi(i, j, k) = max(I(i, j, k), 255 - I(i, j, k));
        end
    end
end
%%
hue_sum = 0;
hr_sum = 0;
for i = 1:m
    for j = 1:n
        hsv_I = rgb2hsv(I(i, j, :));
        hsv_I_semi = rgb2hsv(I_semi(i, j, :));
        h(i, j) = abs(hsv_I(:,:,1) - hsv_I_semi(:,:,1));
        hue_sum = hue_sum + h(i, j);
        if h(i, j) >= 0 && h(i, j) <= 0.5
            r_h(i, j) = 1;
        else
            r_h(i, j) = 0;
        end
        hr_sum = hr_sum + r_h(i, j);
    end
end
H_e = hue_sum / (m * n);
H_r = hr_sum / (m * n);
%%
t_l = 0.75;
r_t = zeros(m, n);
image = double(I);
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
te_sum = 0;
tr_sum = 0;
for i = 1:m
    for j = 1:n
        te_sum = te_sum + t(i, j);
        if t(i, j) >= 0.75 && t(i, j) <= 1
            r_t(i ,j) = 1;
        else
            r_t(i ,j) = 0;
        end
       tr_sum = tr_sum + r_t(i, j);
    end
end
T_e = te_sum / (m * n);
T_r = tr_sum / (m * n);
%%
I_semi = uint8(I_semi);
figure;
subplot(1,2,1);imshow(I);
subplot(1,2,2);imshow(I_semi);