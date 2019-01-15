function [ err ] = computeErr( net, data, class, type_err, varargin )
%COMPUTEERR Compute the error of NET, given TYPE_ERR

if strcmp(type_err, 'costfunc')
    err = mlperr(net, data, class)/size(data, 1);
    
elseif strcmp(type_err, 'auc')
    scores = mlpfwd(net, data);
    if net.nout == 2
        scores = scores(:, 1);
        class = class(:, 1);
    end
    
    [~, ~, ~, err] = perfcurve(class, scores, 1);
end

end
