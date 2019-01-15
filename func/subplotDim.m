function [ dim1, dim2] = subplotDim( nbFig )
%SUBPLOTDIM Give subplot dimension given NBFIG the number of figures to
%subplot

switch nbFig
    case 1
        dim1 = 1;
        dim2 = 1;
    case 2
        dim1 = 1;
        dim2 = 2;
    case 3
        dim1 = 3;
        dim2 = 1;
    case 4
        dim1 = 2;
        dim2 = 2;
end

