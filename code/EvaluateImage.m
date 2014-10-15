function map = EvaluateImage(Cparams, imns, scale)

oim = imns;
if(size(imns,3)>1)
    imns = rgb2gray(imns);
end
imns = double(imns);

W=Cparams.W; H=Cparams.H;
sq = W * H;

threshold = Cparams.threshold;
fmat = Cparams.fmat';
alphas = Cparams.alphas';
theta = Cparams.Thetas(:,2);
p = Cparams.Thetas(:,3);
p_m_theta = p.*theta;
step_slide_w = 1;
step_slide_h = 1;

n_first = 1000;
fmat_first = fmat(1:n_first,:);
alphas_first = alphas(1,1:n_first);
p_first = p(1:n_first,1);
p_m_theta_first = p_m_theta(1:n_first,1);
threshold_first = threshold*n_first/size(fmat,1);

sim = imresize(imns, scale);
ii_im = cumsum(cumsum(sim),2);
ii2_im = cumsum(cumsum(sim.^2),2);
w = size(sim,2);
h = size(sim,1);
map = ones(size(sim,1)-W+1, size(sim,2)-H+1)*(-inf);

for i=2:step_slide_w:w-W+1
    for j=2:step_slide_h:h-H+1
        mu = (ii_im(j-1, i-1) + ii_im(j+H-1, i+W-1) - ii_im(j+H-1, i-1) - ii_im(j-1, i+W-1))/sq;
        vr = (ii2_im(j-1, i-1) + ii2_im(j+H-1, i+W-1) - ii2_im(j+H-1, i-1) - ii2_im(j-1, i+W-1)-sq*mu*mu)/(sq-1);
        if(vr>20)
            subim = (sim(j:j+H-1,i:i+W-1) - mu)/sqrt(vr);
            ii_subim = cumsum(cumsum(subim),2);
            ii_subim = ii_subim(:);            
            fs_first = fmat_first * ii_subim;
            r_first = alphas_first*(p_first.*fs_first<p_m_theta_first);
            if( r_first > threshold_first )
                fs = fmat * ii_subim;
                r = alphas*(p.*fs<p_m_theta);
                map(j,i) = r - threshold;
            end
        end
    end
end
