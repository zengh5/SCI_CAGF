function RP = getFingerprint_CAGM1024(Images)
eps = 0.03;
database_size = length(Images);             % Number of the images
t=0;
for i=1:database_size
    SeeProgress(i),
    im = Images(i).name;
    X = double(imread(im));
    [M,N,three]=size(X);
    X = X((M/2-383):(M/2+384),(N/2-511):(N/2+512),:);
    % For speed consideration, the center 768*1024 is cropped
    [M,N,three]=size(X);
    %%%  Initialize sums
    if t==0
        for j=1:3
            RPsum{j}=zeros(M,N,'single');
            NN{j}=zeros(M,N,'single');
            % number of additions to each pixel for RPsum
        end
    else
    end
    t=t+1;
    for j=1:3
        %%%%%%%%%%%%%%%% CAGM Begin
        Ix = X(:,:,j);
        TV = compute_TV(Ix)/(M*N);
        if TV < 36
            q = CAguidedfilter_zh(Ix/255, 6-round(TV/8), eps);
        else
            q = CAguidedfilter_zh(Ix/255, 2, 0.02);
        end
        ImNoise = single(Ix - 255*q);
%         bigindex = find(abs(ImNoise(:))>5);
%         ImNoise(bigindex) = 25./ImNoise(bigindex);
        % % uncomment the above two lines to attenuate big values
        %%%%%%%%%%%%%%%%%%%%%%%CAGM End
        Inten = single(IntenScale(X(:,:,j))).*Saturation(X(:,:,j));
        RPsum{j} = RPsum{j}+ImNoise.*Inten;
        NN{j} = NN{j} + Inten.^2;
    end
end

clear ImNoise Inten X
RP = cat(3,RPsum{1}./(NN{1}+1),RPsum{2}./(NN{2}+1),RPsum{3}./(NN{3}+1)); % why ^+1
% Remove linear pattern and keep its parameters
[RP,LP] = ZeroMeanTotal(RP);
RP = single(RP);               % reduce double to single precision

