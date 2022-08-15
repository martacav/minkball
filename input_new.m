function I = input_new(optT, optLB, optMT, maxTime, feasTol, initx, initr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function I = input_new(optT, optLB, optMT, maxTime, initx, initr)

% Author       : Marta Cavaleiro
% Description  : Creates a struct with the algorithm input parameters
% Input        : optT ~ tree design option (1-lexic, 2-by distance, 3-by radius)
%                optLB ~ which lower bound info to use (0-none, 1-SOCP, 2-QP)
%                optMT ~ minimum tree used? 1 or 0 (yes or no)
%                maxTime ~ maximum time allowed
%                feasTol ~ covering feasibility tolerance 
%                initx ~ center of initial solution
%                initr ~ radius of initial solution
% Output       : I ~ input struct
% Last revised : 18 June 2021


I.treeDesign = optT;
I.nodeLB = optLB;
I.minTree = optMT;
I.maxTime = maxTime;
I.feasTol = feasTol;
I.initx = initx;
I.initr = initr;

end