%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation of a saliency map from an image. 
%   
% Usage:
%     img = imread('img.jpg');
%     SM = Saliency(img);
%
% Input:
%    img: RGB image
%
% Output:
%    SM: Saliency map of the input image
%  
% Project web-page:
% soe.ucsc.edu/~chkim/SaliencyDetection.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function smap = Saliency(img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%                      GENERAL SETUP                         %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M, N, ~] = size(img);
img = imresize(img, 250/max([M,N]), 'bilinear');    % Scale the test image to the same size of 250 pixels (largest dimension)
patch_size = 7;                                     % patch size
R = [ 0.8, 0.5, 0.3];                               % Multi-scales for the input image
Rq = [1.0, 0.5, 0.25];                              % Search scales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%               SALIENCY (MULTI-SCALE)                       %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smap_all = zeros(size(img,1),size(img,2),length(R));
for i=1:length(R) 
    disp(['Scale:', num2str(i)]);
    r_img = imresize(img, R(i), 'bilinear');      
    temp = R(i) * Rq;         
    Rq = Rq(temp>=0.2);                             % The smallest scale allowed is 20% of the original image scale.    
        
    [dissim, new_M, new_N] = GetDissimilarities(r_img, Rq, patch_size);
        
    t_smap = Aggregation(dissim);
    t_smap = reshape(t_smap, [new_M, new_N]);
    t_smap = imresize(t_smap, [M,N], 'bilinear');
    
    smap_all(:,:,i) = imresize(t_smap, [size(img,1),size(img,2)], 'bilinear');
end

smap = sum(smap_all,3)/length(R);       % combine all saliency maps from different scales
smap = smap - min(smap(:));             % normalization
smap = smap/max(smap(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


smap = imresize(smap, [M, N], 'bilinear');
end
        