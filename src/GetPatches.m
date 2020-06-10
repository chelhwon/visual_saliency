function result = GetPatches(img, patch_size)
% sample vectorized patches in LARK image 
% INPUT:    
%       img: input image
%       patch_size: patch size
% OUTPUT:
%       lark: vectorized patch sampled from the lark image

[M, N, ~] = size(img);
h_patch_size = (patch_size-1)/2;

% control parameters for LARK computation
P = 3;          % LARK window size
alpha = 0.42;   % LARK sensitivity parameter
h = 0.2;        % smoothing parameter for LARK

Lab = im2double(colorspace('Lab<-RGB',img));
larks = zeros(M,N,3*P*P);
for c = 1:3
    t_img = Lab(:,:,c);
    t_img = t_img - min(t_img(:));
    t_img = t_img/max(t_img(:));
    % Compute LARKs at every pixel points
    temp = ComputeLARK(t_img, P, alpha, h); %0.43 0.6 --> 0.6828 %0.43 0.4 --> 0.6842 %0.42, 0.2 --> 0.6914   
    larks(:,:, 1+(c-1)*P*P:c*P*P) =  temp;
end

% extend
ext_larks = [larks(:, h_patch_size+1:-1:2,:), larks, larks(: ,end-1:-1:end-h_patch_size,:)];
ext_larks = [ext_larks(h_patch_size+1:-1:2, :,:); ext_larks; ext_larks(end-1:-1:end-h_patch_size, :,:)];


result = zeros(M,N,3*P*P* patch_size*patch_size);
      
cnt = 1;
for j=1:patch_size
    for k=1:patch_size
        result(:,:, 1+3*P*P*(cnt-1):3*P*P*cnt) = ext_larks(j:j+M-1, k:k+N-1, :);
        cnt = cnt + 1;
    end
end