
% The code is implemented by Hui Zeng in 2015
% [1] Hui Zeng, Xiangui Kang 'Fast Source Camera Identification Using Content
% Adaptive Guided Image Filter' Jouranl of Forensic Sciences, 2016,
% 61(2):520-526.
% The code is based on the following paper£º
% [2] Li Z, Zheng J, Zhu Z. Content adaptive guided image filtering. 2014 ICME
% Please cite the original work if it is helpful
function q = CAguidedfilter_zh(I, r, eps)
%   GUIDEDFILTER   O(1) time implementation of guided filter.
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p = I
%   - local window radius: r
%   - regularization parameter: eps
% when I=p (use itself as guide), the code can be simplied
L = max(I(:))-min(I(:));
v1 = (0.001*L)^2;
v2 = 1e-9;
% zeta =0.75;        % Content adaptive parameters
%%%%%%%%%%%%%
[hei, wid] = size(I);
N = boxfilter(ones(hei, wid), r);
% the size of each local patch; N=(2r+1)^2 except for boundary pixels.
mean_I = boxfilter(I, r) ./ N;
mean_Ip = boxfilter(I.*I, r) ./ N;
cov_Ip = max(mean_Ip - mean_I .* mean_I,0);
% this is the covariance of (I, p) in each local patch.
%%%%%%%%%%%%%%% (7) of [1] or (5) of [2]
localweight = ((cov_Ip+v1)./(mean_I .* mean_I+v2)).^0.75;
temp1 = 1./localweight ;
temp2 = mean(temp1(:));
Tao = temp2*localweight;
%%%%%%%%%%%%%%%%%
a = cov_Ip ./ (cov_Ip + eps./Tao); % Eqn. (7) of [2];
b = (1- a) .* mean_I; % Eqn. (8) of [2];
mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;
q = mean_a .* I + mean_b; % Eqn. (9) in the  Li's paper;
end