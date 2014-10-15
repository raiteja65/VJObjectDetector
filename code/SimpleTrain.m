% trains an ada-boost model on tiny faces
% adjust the parameters according to your available system memory

nTrainPosData = 4000;
nTrainNegData = 8000;
nTestPosData = 500;
nTestNegData = 1000;
nLevels = 100;
W = 19;
H = 19;

posImageDir = '../data/TinyFaces/FACES/';
negImageDir = '../data/TinyFaces/NFACES/';

PTrainData = zeros(W, H, nTrainPosData);
NTrainData = zeros(W, H, nTrainNegData);

pfiles = dir([posImageDir '*.bmp']);
nfiles = dir([negImageDir '*.bmp']);

aa = 1:length(pfiles); a = randperm(length(aa)); trainPosPerm = aa(a(1:nTrainPosData));
aa = 1:length(nfiles); a = randperm(length(aa)); trainNegPerm = aa(a(1:nTrainNegData));

testPosPerm = setdiff(1:length(pfiles), trainPosPerm);
testNegPerm = setdiff(1:length(nfiles), trainNegPerm);

PTestData = zeros(W, H, nTestPosData);
NTestData = zeros(W, H, nTestNegData);

% read train data
disp('preparing training data...');
for i=1:size(PTrainData,3)
    PTrainData(:,:,i) = imread([posImageDir pfiles(trainPosPerm(i)).name]);
end
for i=1:size(NTrainData,3)
    NTrainData(:,:,i) = imread([negImageDir nfiles(trainNegPerm(i)).name]);
end

% read test data
disp('preparing test data...');
for i=1:size(PTestData,3)
    PTestData(:,:,i) = imread([posImageDir pfiles(testPosPerm(i)).name]);
end
for i=1:size(NTestData,3)
    NTestData(:,:,i) = imread([negImageDir nfiles(testNegPerm(i)).name]);
end

% find classifier parameters
disp('training the model...');
Cparams = Train(PTrainData, NTrainData, PTestData, NTestData, nLevels);

save('../cache/Cparams.mat', 'Cparams');
