% The code is based on the open source code of DDE:
% http://dde.binghamton.edu/download/camera_fingerprint/
% Please cite the original work if it is helpful

% Function: Generate the camera fingerprint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileList=dir('The directory of your images\*.jpg');
for Fi=1:50
    imx=strcat('The directory of your images\',FileList(Fi).name);
    Images(Fi).name = imx;
end
RP = getFingerprint_CAGM1024(Images);
RP = rgb2gray1(RP);
Fingerprint = WienerInDFT(RP,std2(RP));
save Sample/FingerprintName.mat Fingerprint;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
