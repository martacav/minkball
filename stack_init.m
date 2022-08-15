function [stack, s] = stack_init(m, k)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [stack, s] = stack_init(m, k)
%
% Author       : Marta Cavaleiro
% Description  : Creates the stack with size m-k+1 that keeps the live nodes
% Input        : m ~ number of points in P
%                k ~ the number of points we want to cover
% Output       : stack ~ the stack with structs node
%                s ~ position of the head of the stack
% Last revised : 23 June 2016

stack = repmat(node_new(), 1, m-k+1);
s=0;

end