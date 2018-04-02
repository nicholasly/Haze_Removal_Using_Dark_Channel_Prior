function GC = GammaCorrected(img, alpha, gamma)
    GC = alpha * img .^ gamma;
end