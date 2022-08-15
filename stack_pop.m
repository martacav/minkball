function [node, stack, s] = stack_pop(stack, s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [node, stack, s] = stack_pop(stack, s)
%
% Author       : Marta Cavaleiro
% Description  : Removes and returns the head of the stack
% Input        : stack ~ stack of live nodes
%                s ~ position of the head of the stack        
% Output       : node ~ head of the stack
%                stack ~ stack of live nodes
%                s ~ position of the head of the stack
% Last revised : 23 June 2016

node = stack(s);
%stack(s) = node_new ();
s = s-1;

end