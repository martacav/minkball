function N = node_new (p, l, i, path, x, r, S, lb, subtree)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function N = node_new (p, l, i, path, x, r, S, lb, subtree)
%
% Author       : Marta Cavaleiro
% Description  : Creates a node struct
% Input        : p ~ index of the point
%                l ~ level
%                i ~ index / position
%                path ~  indexes of the points on the path from the root to this node 
%                x ~ center of the ball
%                R ~ radius of the ball
%                S ~ support set of the ball
%                lb ~ lower bound on the smallest radius of the node's leaves
%                subtree ~ indexes of the points assigned to the subtree of this node
% Output       : N ~ node struct
% Last revised : 23 June 2016


if nargin > 0
    N.point = p;
    N.level = l;
    N.index = i;
    N.path = path;
    N.x = x;
    N.r = r;
    N.S = S;
    if lb < r
        N.lb = r;
    else
        N.lb = lb;
    end
    N.subtree = subtree;

else
    N.point = 0;
    N.level = 0;
    N.index = 0;
    N.path = [];
    N.x = [];
    N.r = 0;
    N.S = [];
    N.lb = [];
    N.subtree = [];
end

end