function WB = WhiteBalance(img)
    img = double(img);
    [m, n, ~] = size(img);
    % fetch each color channel
    r = img(:,:,1);
    g = img(:,:,2);
    b = img(:,:,3);
    % calculate mean value for each color channel
    meanR = mean(r(:)); 
    meanG = mean(g(:)); 
    meanB = mean(b(:));
    meanRGB = [meanR meanG meanB];
    % calculate grayvalue and scale value
    grayValue = (meanR + meanG + meanB) / 3 ;
    scaleValue = grayValue ./ (meanRGB + 0.001); 
    R = scaleValue(1) * r;
    G = scaleValue(2) * g;
    B = scaleValue(3) * b;
    for i = 1:m
        for j = 1:n
            if (R(i,j) > 255)
                R(i,j) = 255;
            end
            if (G(i,j) > 255)
                G(i,j) = 255;
            end
            if (B(i,j) > 255)
                B(i,j) = 255;
            end
        end
    end
    new(:,:,1)=R;
    new(:,:,2)=G;
    new(:,:,3)=B;
    WB = new; 
    imwrite(WB, 'WB.png');
end