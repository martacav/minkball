function sbt = getOrderedSubtree (optT, N, P, normSqP, k)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sbt = getOrderedSubtree (optT, N, P, normSqP)
%
% Author       : Marta Cavaleiro
% Description  : Chooses which points of N's subtree to assign to N's child nodes
%                If optT 1 is selected, choice is made lexicographically.
%                If optT 2 is selected, the points to be assigned
%                to the child nodes are farthest points from N.x (center). 
% Input        : optTs ~ specifies the tree design method: 
%                1: lexicographically; 
%                2: sorted by distance to the current node's center, descending
%                N ~ node N
%                P ~ set of points
%                normSqP ~ squared norms of the points in P
% Output       : sbt ~ index of the points of the subtree sorted descendingly by 
%                distance to N.x  
% Last revised : 18 June 2021

m = size(P, 2);
switch (optT)
    
     case 1 %lexicographically
         if N.level==0
             sbt = (1:m)';
         else
             sbt = N.subtree;
         end
         
     case 2 %the farthest points from the center, the farthest first
        if N.level == 0
            [xP, ~, ~, ~, ~] = minBallDualAlg (P);
            distTox = -2*P'*xP + normSqP;
            [~, sbtA] = maxk(distTox, m-k+1); 
            aux = (1:m)'; 
            sbtB = aux(~ismember(aux,sbtA)); 
            sbt = [sbtA; sbtB]; %return the indexes of the points of the subtree with the farthest on the front        
        
        else            
           distTox = -2*P(:, N.subtree)'*N.x + normSqP(N.subtree);
           [~, IA] = maxk(distTox, m-k+N.level-N.index+1);                    
           IB = ~ismember(N.subtree,N.subtree(IA));  
           sbt = [N.subtree(IA); N.subtree(IB)]; 

        end
end
end