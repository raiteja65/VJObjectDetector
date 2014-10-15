function dets = FastScanImage(Cparams, imns, min_s, max_s, step_s, jump)

if(size(imns,3)>1), imns = rgb2gray(imns); end
imns = double(imns);
if nargin<5, step_s = 0.1; end
if nargin<6, jump = false; end
if step_s<=1, error('step_s should be higher than one!'); end

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

n_first = 1;
fmat_first = fmat(1:n_first,:);
alphas_first = alphas(1,1:n_first);
p_first = p(1:n_first,1);
p_m_theta_first = p_m_theta(1:n_first,1);
threshold_first = threshold*n_first/size(fmat,1);

s=max_s;

dets = [];

while s>=min_s
    sim = imresize(imns, s);
    ii_im = cumsum(cumsum(sim),2);
    ii2_im = cumsum(cumsum(sim.^2),2);
    sdets = [];    
    w = size(sim,2);
    h = size(sim,1);
    if jump
        step_slide_w = floor(max(1, w/60));
        step_slide_h = floor(max(1, h/60));
    end
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
                    if r>threshold
                        sdets = [sdets; i,j,W,H];
                    end
                end
            end
        end
    end
    nd = size(sdets,1);
    if nd > 0
        dets = [dets; sdets/s];
    end
    s = s/step_s;
end

if ~isempty(dets)
    dets = PruneDetections(dets);
end

