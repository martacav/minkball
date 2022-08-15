function [rOpt, xOpt, O] = minkBall(P, k, I)  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [xOpt, rOpt, O] = minkBall(P, k, I)  
%
% Author       : Marta Cavaleiro
% Description  : Finds the minimum radius ball that encloses at least k of 
%                the points in P
% Features     : Nodes are inserted on the  pool of live nodes using LIFO 
%                strategy; Nodes are sorted by distance or lexicographicaly;
%                The use of the minimum tree is specified in struct I;
% Input        : P ~ matrix of the points of P (points on the columns)
%                k ~ number of points to cover (1 <= k <= m)
%                I ~ struct with input options (see input_new.m)
% Output       : xOpt ~ center of the solution
%                rOpt ~ radius of the solution
%                O ~ struct with algorithm statistics and other information
%                (see output_new.m)
% Last revised : 12 september 2019


%-----------------------------INITIALIZATION------------------------------
m = size(P, 2);
if k>m
    disp('Error: k larger than number of points.')
    return
end

tic  %starting time
global epsTol
epsTol = I.feasTol;
optCh = I.treeDesign;
optLB = I.nodeLB;
optT = I.minTree;
O = output_new(); 
best =  node_new({}, k, {}, {}, I.initx, I.initr, {}, I.initr, {}); 
[stack, s] = stack_init(m, k); 
normSqP = sum(P.^2, 1)';     
pairDistsP = pdist2(P', P'); 


%---------------------------------MAIN -----------------------------------
%0. CREATE ROOT AND INSERT IN STACK
root = node_new([], 0, 0, [], [], 0, [], 0, (1:m)');
[stack, s] = stack_insert(stack, s, root); 

while s>0 %stack is non empty
        
    if toc > I.maxTime
       O.time = toc;
       O.status = 'MAXTIME';
       xOpt = best.x;
       rOpt = best.r;
       O.rUB = best.r;
       return 
    end
    
    %1.CHOOSE A BRANCHING NODE
    [N, stack, s] = stack_pop(stack, s);
    O.BN = O.BN+1;
    
    %2.GET A BETTER LOWER BOUND (IF optLB>0 AND LEVEL APPLIES)
    [N.lb, lbflag] = nodeLB_main(optLB, P, k, N, pairDistsP, normSqP);
    O.LBCalls = O.LBCalls + lbflag;       
    
    %3. COMPARE LOWER BOUND WITH BEST    
    if N.lb >= best.r
        continue
    end
       
    %4.GET N'S CHILDREN
    numChildren = m-k+N.level-N.index+1;
    N.subtree = getOrderedSubtree(optCh, N, P, normSqP, k);
    if optT == 1  %MINIMUM TREE IS USED
        lasti = numChildren - 1; %last node is treated separately (see point 6.)
    else
        lasti = numChildren;
    end
         
    %5.EXPLORE EACH CHILD
    for i = 1:lasti       
        pt = N.subtree(i);      
        
        %5.1 CALCULATE THE RADIUS OF CHILD NODE   
        [Cx, Cr, CS, daIter, expc] = minBallBB(P(:, N.path),P(:,pt),N.S,N.x,N.r,best.r,normSqP(N.path),normSqP(pt),pairDistsP(N.path, pt)); 
        O.EN = O.EN + expc;
        O.DA = O.DA + daIter;

        if Cr < best.r            
            %5.2 CHECK IF CHILD NODE CAN BE PRUNED OR IF IT IS FEASIBLE AND UPDATE best:
            if N.level == k-1 || coversKPoints (Cx, Cr, k, P, normSqP)
                best =  node_new({}, {}, {}, [N.path; pt], Cx, Cr, CS, 0, {});
                O.optEN = O.EN;
            end  
            
            %5.3 ADD CHILD TO active
            child = node_new(pt, N.level+1, N.index+i, [N.path; pt], Cx, Cr, CS, N.lb, N.subtree(i+1:end));
            [stack, s] = stack_insert(stack, s, child);
        end       
    end
    
    
    %6.WHEN optT=1 (MINIMUM TREE IS USED) TAKE CARE OF LAST CHILD NODE:
    if optT == 1
        subpath = N.subtree(numChildren:end);
        [Cx, Cr, CS, daIter, expc] = minBallBB(P(:, N.path),P(:,subpath),N.S,N.x,N.r,best.r,normSqP(N.path),normSqP(subpath), pairDistsP(N.path, subpath));
        O.EN = O.EN + expc;
        O.DA = O.DA + daIter;

        if Cr < best.r
            best =  node_new({}, {}, {}, [N.path; subpath], Cx, Cr, CS, 0, {});
            O.optEN = O.EN;          
        end
    end
    

end

O.status = 'Optimal';
O.time = toc;
xOpt = best.x;
rOpt = best.r;
end