function thresh = ComputeROC(Cparams, PositiveData, NegativeData)

W = size(PositiveData,2);
H = size(PositiveData,1);

n_f = size(PositiveData,3);
n_nf = size(NegativeData,3);

ii_fs = zeros(n_f, W*H);
ii_nfs = zeros(n_nf, W*H);

for i=1:n_f
    [im, ii_im] = CalcIntegralImage(PositiveData(:,:,i));
    ii_fs(i,:) = ii_im(:)';
end

for i=1:n_nf
    [im, ii_im] = CalcIntegralImage(NegativeData(:,:,i));
    ii_nfs(i,:) = ii_im(:)';
end

sc_f = ApplyDetector(Cparams, ii_fs);
sc_nf = ApplyDetector(Cparams, ii_nfs);

num = 500;
curThreshold = min(min(sc_f), min(sc_nf));
maxThreshold = max(max(sc_f), max(sc_nf));
dt = (maxThreshold-curThreshold)/num;
tpr = zeros(1, num);
fpr = zeros(1, num);

found = false;
thresh = 0;

for i=1:num
    tpos = sum(sc_f >= curThreshold);
    fneg = n_f - tpos;

    tneg = sum(sc_nf < curThreshold);
    fpos = n_nf - tneg;

    tpr(i) = tpos/(tpos+fneg);
    fpr(i) = fpos/(tneg+fpos);
    
    if ~found && (tpr(i)<0.95)
        thresh = curThreshold;
        disp(sprintf('Above 95 percent positive rate threshold: %f', curThreshold));
        found = true;
    end
    
    curThreshold = curThreshold + dt;
end

plot(fpr, tpr, '-r', 'LineWidth',2);
