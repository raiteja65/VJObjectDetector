function fdets = PruneDetections(dets)

nd = size(dets, 1);

D = sparse(nd, nd);

area = rectint(dets, dets);
D(area>0) = 1;

[S, C] = graphconncomp(D);

fdets = zeros(S, 4);
m = zeros(S, 1);

for i=1:nd
    fdets(C(i),:) = fdets(C(i),:) + dets(i,:);
    m(C(i)) = m(C(i))+1;
end

fdets = int32(fdets./(m*ones(1,4)));
