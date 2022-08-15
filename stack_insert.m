function [stack, s] = stack_insert(stack, s, new)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [stack, s] = stack_insert(stack, s, new)
%
% Author       : Marta Cavaleiro
% Description  : Inserts new item in the stack that keeps the live nodes
% Input        : stack ~ stack of live nodes
%                s ~ position of the head of the stack
%                new ~ node to insert        
% Output       : stack ~ stack of live nodes
%                s ~ position of the head of the stack
% Last revised : 23 June 2016

s = s+1;
stack(s) = new;

end