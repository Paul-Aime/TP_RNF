function [ pOut, legendsOut ] = formatLegends( p, legends, varargin )
%FORMATLEGENDS(P, LEGENDS) Retourne les handle et l�gendes d�sir�es
%
%   Cette fonction sert � n'avoir qu'une seule l�gende pour une courbe 
%   trac�e en plusieurs coup, pour laquelle par d�faut s'affichent
%   plusieurs fois la m�me l�gende.
%
%   En mettant en troisi�me argument une cha�ne de caract�re sp�cifique,
%   toute l�gende correspondant � cette cha�ne de caract�re sera rejet�e,
%   ce qui permet alors de choisir sp�cifiquement les l�gendes que l'on
%   veut rejeter, en les nommant de cette mani�re.
%   
%            P - handle de chaque plot pr�sent dans l'affiche
%      LEGENDS - l�gendes associ�es
%         POUT - handle des l�gendes que l'on garde
%   LEGENDSOUT - l�gendes associ�es � POUT
%     VARARGIN - mot cl� � rejeter syst�matiquement

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

