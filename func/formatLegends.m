function [ pOut, legendsOut ] = formatLegends( p, legends, varargin )
%FORMATLEGENDS(P, LEGENDS) Retourne les handle et légendes désirées
%
%   Cette fonction sert à n'avoir qu'une seule légende pour une courbe 
%   tracée en plusieurs coup, pour laquelle par défaut s'affichent
%   plusieurs fois la même légende.
%
%   En mettant en troisième argument une chaîne de caractère spécifique,
%   toute légende correspondant à cette chaîne de caractère sera rejetée,
%   ce qui permet alors de choisir spécifiquement les légendes que l'on
%   veut rejeter, en les nommant de cette manière.
%   
%            P - handle de chaque plot présent dans l'affiche
%      LEGENDS - légendes associées
%         POUT - handle des légendes que l'on garde
%   LEGENDSOUT - légendes associées à POUT
%     VARARGIN - mot clé à rejeter systématiquement

legendsOut = {};
idxs = [];
idx = 0;
pOut = [];

if nargin == 3
    throwoutStr = varargin{1};
end
if nargin > 3
    return
end

for legend1 = legends
    idx = idx + 1;
    
    if strcmp(legend1, throwoutStr)
        continue
    end
    
    for legend2 = legendsOut
        if strcmp(legend1, legend2)
            continue
        end
    end
    
    legendsOut = [legendsOut legend1];
    pOut = [pOut p(idx)];
    
end

end

