function [dissim, new_M, new_N] = GetDissimilarities(img, Rq, patch_size)
% compute the photometric distance and the spatial distance
% INPUT: 
%       img: input image
%       Rq: multi-scales
%       patch_size: patch size
% OUTPUT:
%       dissim: photometric distance for each pixel in the image. 
%                each row includes the distance measure of the patch at
%                that pixel relative all patches observed in the images 
%                whose scales are Rq.
%       new_M*newN: number of patches sampled in the image. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample patches 
h_patch_size = (patch_size-1)/2;
[M, N, ~] = size(img);
cell_lark = cell(1, length(Rq));

% For each scale, gather vectorized patches in LARK 
for i=1:length(Rq)    
    r_img = imresize(img, Rq(i), 'bilinear');
    t_lark = GetPatches(r_img, patch_size);
    
    % sample patches with 50% overlap
    t_lark = t_lark(1:h_patch_size:end, 1:h_patch_size:end, :);
    temp = reshape(t_lark, size(t_lark,1)*size(t_lark,2), size(t_lark,3));
    cell_lark{1,i} = temp';
end
larks = cell2mat(cell_lark);

% number of patches sampled on the test image. 
new_M = length(1:h_patch_size:M);
new_N = length(1:h_patch_size:N); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute dissimilarities
temp = ones(size(larks,1),1)*sqrt(sum(larks.*larks));
larks = larks./temp;    %  normalization

dissim = larks(:, 1:new_M*new_N)' * larks;
dissim = exp(-dissim);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
