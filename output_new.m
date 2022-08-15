function O = output_new (t, BN, EN, optEN, DA, LB, status, rLB, rUB)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function O = output_new (t, BN, EN, optEN, DA, LB, status, rLB, rUB)
%
% Author       : Marta Cavaleiro
% Description  : Creates a struct with the algorithm output information
% Input        : t ~ time
%                BN ~ number of branched nodes
%                EN ~ number of explored nodes
%                optEN ~ number of explored nodes when optimal was found
%                DA ~ number of dual iterations of min ball algorithm
%                LB ~ number of times LB was called
%                status ~ exit status of the algorithm
%                rUB ~ upper bound on the optimal radius
% Output       : O ~ output struct
% Last revised : 23 June 2021

if nargin > 0
    O.time = t;
    O.BN = BN;
    O.EN = EN;
    O.DA = DA;
    O.optEN = optEN;
    O.LBCalls = LB;
    O.status = status;
    O.rUB = rUB;
else
    O.time = 0;
    O.BN = 0;
    O.EN = 0;
    O.DA = 0;
    O.optEN = 0;
    O.LBCalls = 0;
    O.status = [];
    O.rUB = Inf;    
end

end
