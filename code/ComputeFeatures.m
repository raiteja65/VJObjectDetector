function features = ComputeFeatures(data, all_ftypes)

W = size(data,2); 
H = size(data,1);
ni = size(data,3);

ii_ims = zeros(ni, W*H);

for i=1:ni
    [im, ii_im] = CalcIntegralImage(data(:,:,i));
    ii_ims(i,:) = ii_im(:)';
end

fmat = VecAllFeatures(all_ftypes, W, H);
fs = ii_ims * fmat;

features.fs = fs;
features.ii_ims = ii_ims;

end
