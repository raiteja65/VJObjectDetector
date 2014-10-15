function Cparams = Train( PTrainData, NTrainData, PTestData, NTestData, T )

W = size(PTrainData,2);
H = size(PTrainData,1);

all_ftypes = EnumAllFeatures(W, H);

Cparams = BoostingAlg(PTrainData, NTrainData, all_ftypes, T);

Cparams.threshold = ComputeROC(Cparams, PTestData, NTestData);

end
