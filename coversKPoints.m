function value = coversKPoints (x, r, k, P, normSqP)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author       : Marta Cavaleiro
% Description  : Checks if a ball covers at least k points of P
% Input        : x ~ center
%                r ~ radius
%                k ~ number of points to check
%                P ~ set of points
%                normSqP ~ %squared norms of the points in P
% Output       : value ~ true (1) or false (0)
% Last revised : 18 February 2019

global epsTol

if nargin == 4
    normSqP = sum(P.^2, 1)';
end

distTox = -2*P'*x + normSqP;
feasPts = nnz(distTox <= (r+epsTol)^2 - x'*x);

if feasPts >= k
     value = 1;
else
     value = 0;
end

end