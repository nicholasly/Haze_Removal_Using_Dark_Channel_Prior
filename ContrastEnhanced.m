function CE = ContrastEnhanced(img)
    % improve the contrast of the image
    CE = (2 * (0.5 + mean(img(:)))) .* (img - mean(img(:)));
end