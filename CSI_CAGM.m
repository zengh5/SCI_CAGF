% Extracting the sensor pattern noise with the Content Adaptive Guided Image Filter
% [1] Hui Zeng, Xiangui Kang 'Fast Source Camera Identification Using Content
% Adaptive Guided Image Filter' Jouranl of Forensic Sciences, 2016,
% 61(2):520-526.
% [2] Z. Li, J. Zheng, and Z. Zhu 'CONTENT ADAPTIVE GUIDED IMAGE FILTERING', ICME2014
% The code is based on the open source code of DDE:
% http://dde.binghamton.edu/download/camera_fingerprint/
% Please cite the original work if it is helpful

clc,clear,
% The utilities in this folder are copied from the the open source code of DDE
addpath('Functions')
% Load the generated camera fingerprint, the fingerprint is cropped from
% the center 768*1024 pixels
% You may generate your own camera fingerprint with FPcreat_CAGM()
load Sample/Fingerprint_kodakC0_1024_eCAGF.mat;
Fingerprint_kodakC0 = Fingerprint;
% An important parameter in CAGIF, typically range from [0.01, 0.04]
eps = 0.02;
[Mf,Nf] = size(Fingerprint);

%%%%%%%%%%%%%%%%%%%%%%%%%
Flist = dir('Sample\*.jpg');
for i = 1:3
    i,
    %%%%%%%%%%%%%%%%
    imx = ['Sample\',Flist(i).name];
    Ix = single(rgb2gray(imread(imx)));
    [M,N] = size(Ix);
    Ix = Ix((M/2-Mf/2+1):(M/2+Mf/2),(N/2-Nf/2+1):(N/2+Nf/2));
    % (8) in [1]
    TV = compute_TV(Ix)/(Mf*Nf);
    if TV < 36
        q = CAguidedfilter_zh(Ix/255, 6-round(TV/8), eps);
    else
        q = CAguidedfilter_zh(Ix/255, 2, 0.01);
    end
    % (2) in [1]
    Noisex = ZeroMeanTotal(Ix - 255*q);
    % (9) in [1]
    Noisex = max(min(Noisex,6),-6);
    Noisex = WienerInDFT(Noisex,std2(Noisex));
    %%%%%%%%%%%%%%%%%%%%
    C(i) = PCE1(crosscorr(Noisex,Ix.*Fingerprint_kodakC0));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
