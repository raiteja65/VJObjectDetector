function Cparams = BoostingAlg(PositiveData, NegativeData, all_ftypes, T)

W = size(PositiveData,2);
H = size(PositiveData,1);

PositiveFeatures = ComputeFeatures(PositiveData, all_ftypes);
NegativeFeatures = ComputeFeatures(NegativeData, all_ftypes);

np = size(PositiveFeatures.fs, 1);
nn = size(NegativeFeatures.fs, 1);
nf = size(PositiveFeatures.fs, 2);

ys = [ones(np, 1); zeros(nn, 1)];
ws = [ones(np, 1)/(2*np); ones(nn, 1)/(2*nn)];

alphas = zeros(T, 1);
Thetas = zeros(T, 3);

for t=1:T
    ws = ws / sum(ws);
    e = inf;
    i = 1;
    while (i<=nf)
        count = min(nf-i+1, 200);
        fs = [PositiveFeatures.fs(:,i:i+count-1); NegativeFeatures.fs(:,i:i+count-1)];
        [theta, p, err] = LearnWeakClassifier(ws, fs, ys);
        [val, j] = min(err);
        if(err(j)<e)
            e = err(j);
            beta = e/(1-e);
            hs = p(j).*fs(:,j) < p(j).*theta(j);
            wsu = (beta.^(1-abs(hs-ys)));
            Thetas(t,:) = [j+i-1, theta(j), p(j)];
            alphas(t) = log(1/beta);
        end
        i = i + count;
    end
    ws = ws .* wsu;
    disp(sprintf('iteration %d complete', t));
end

Cparams.alphas = alphas;
Cparams.Thetas = Thetas;
Cparams.fmat = VecAllFeatures(all_ftypes(Thetas(:,1),:), W, H);
Cparams.all_ftypes = all_ftypes;
Cparams.W = W;
Cparams.H = H;
