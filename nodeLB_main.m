function [lb, flag] = nodeLB_main(optLB, P, k, N, pairDistsP, normSqP)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function value = nodeLB_main(optLB, m, k, N, pairDistsP, normSqP) 
%
% Author       : Marta Cavaleiro
% Description  : determines whether the lower bound for the node's subtree best solution is to 
%                be used, and when so calculates it
%                **Rules when to apply the LB**
%                 -not on the first level  
%                 -there are more than k points involved, otherwise lb is just a MEB; also excludes leaves
%                 -there must be a large number of points on the subtree, specified by parameter z below
% Input        : optLB ~ LB option-> 0: none; 1: SOCP formulation; 2: QP (big M) formulation;
%                P ~ points covered
%                k ~ number of points to cover
%                N ~ node at which the LB is being calculated
%                nomrSqP ~ squared norms of all vectors in P
%                pairDistsP ~ pairwise distances between points in P
% Output       : lb ~ lower bound on the radius found
%                flag ~ =1 if a LB was calculated; 0 if not (this is used
%                to count the number of LB calculations)
% Last revised : 18 June 2021


if optLB == 0
    flag = 0;
    lb = 0;
    return
end

z = 0.1; %percentage of the total number of nodes present in the subtree
m=size(P, 2);

if N.level>1 && m-N.index+N.level > k && m-N.index > z*m  
    flag = 1;    
    switch optLB
    case 1
        lb = nodeLB_SOCP(P(:, N.path), P(:,N.subtree), k, pairDistsP(N.path, N.subtree));
    case 2
        M = max(max(pairDistsP([N.path; N.subtree], [N.path; N.subtree])))^2;
        lb = nodeLB_QP (P(:, N.path), P(:,N.subtree), k, M, normSqP(N.path), normSqP(N.subtree));           
    end    
else
    flag = 0;
    lb=0;
    return
end

end
