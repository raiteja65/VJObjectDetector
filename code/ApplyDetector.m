function sc = ApplyDetector(Cparams, ii_ims)
ni = size(ii_ims, 1);
theta = Cparams.Thetas(:,2);
p = Cparams.Thetas(:,3);
fs = ii_ims * Cparams.fmat;
hs = fs.*(ones(ni,1)*p') <  ones(ni,1)*(p.*theta)';
sc = hs*Cparams.alphas;
