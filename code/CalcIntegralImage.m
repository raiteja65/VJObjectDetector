function [im, ii_im] = CalcIntegralImage(im)

if size(im,3)>1
    im = rgb2gray(im);
end
im = double(im);
imv = im(:);
s = std(imv);
if(s==0)
    s=1;
end
im = (im-mean(imv))/s;
ii_im = cumsum(cumsum(im),2);
