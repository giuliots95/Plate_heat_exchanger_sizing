function x = checkboundsIntGA(x, range)
% This function adds a subtracts 1 to the variables that are not inside the
% bounds to make them fall inside the defined bounds.
%
% Inputs: 
%           - x: the matrix of mapped variables
%           - range: the matrix of 2 rows and n variables containing the
%           upper and lower values.
%
% Output: 
%           - x: the same input matrix with corrected values (mapped
%           variables)
[~, m] = size(range);

for k = 1:m
x(x(:, k)<range(1, k), k)=x(x(:, k)<range(1, k), k)+1;
x(x(:, k)>range(2, k), k)=x(x(:, k)>range(2, k), k)-1;
end