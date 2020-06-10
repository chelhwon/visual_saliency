function output = Aggregation(d)
% generlized model: saliency = sum(d_k * w_k)
% where w_k = exp(-(d_k-d_r)^2/h), h is the smoothing paramter
h = 1.7866e-006;
output = nan(size(d,1), 1);
for i=1:size(d,1)
    di = d(i,:);
    di(i) = [];                     % ignore the ceter patch
    [dr, idx] = min(di);            % reference, dr
    wi = exp(-(di - dr).^2/h);
    % we set the weight of the reference observation itself as the maximum of
    % the rest of weights for other observations
    wi(idx) = max([wi(1:idx-1), wi(idx+1:end)]);  
    wi = wi / sum(wi);
    output(i) = wi*di';    
end
end