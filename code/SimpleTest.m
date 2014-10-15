% tests ada-boost face detector on a sample image

load('../cache/Cparams.mat');

figure;

tic

im = imread('../data/Test/Group-of-People.jpg');

dets = FastScanImage(Cparams, im, 0.4, 0.6, 1.1, false);

toc

DisplayDetections(im, dets);
