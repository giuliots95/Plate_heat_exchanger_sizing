function x_mapped = map_variables(x, discrete_range)
% Map integer variables to a discrete set of variables
% Inputs: 
%           - matrix (i configurations to evaluate, j variables)
%           of the variables (given in vertical arrays),
%           expressed in the virtual (continuous) domain.
%           
%           - dicrete_range: a cell array (1 x j) containing j arrays o the
%           discrete values that the mapped variable can assume.
%           
% Output:
%           - x_mapped, matrix (i x j) with the mapped variables.
%
x_mapped=x; 
[rows, nvars]=size(x);
for j = 1:nvars
    % the array of the possible discrete values that can be assigned to the
    % mapped variable
    discrete_values=discrete_range{1, j};
    if ~isempty(discrete_values)
        for i=1:rows
            % assign to the correspoondin mapped var the element of the
            % discrete array values in position idx = x(i,j)
            x_mapped(i,j)=discrete_values(1, round(x(i, j)) ); % added round
        end
    end
    
end
end

