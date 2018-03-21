function dark = multiscale_dark_channel(image)
    [m, n, ~] = size(image);
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    
    min_rgb = zeros(m,n);
    for i = 1:m
        for j = 1:n
            min_rgb(i,j) = min(r(i, j), g(i, j));
            min_rgb(i,j) = min(min_rgb(i,j), b(i, j));
        end
    end
    
    % image erode, minimum filtering
    kernel = ones(30);
    dark = imerode(min_rgb, kernel);
    
    %d = ones(20, 20);
    %fun = @(block_struct)min(min(block_struct.data)) * d;
    %dark = blockproc(min_rgb, [20 20], fun);
    
    dark = dark(1:m, 1:n);
