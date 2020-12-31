function y = PHE_obj(x, range, hot_side, cold_side, PHE_properties)
% This function evaluates the optimization objectives.
%
% Inputs:
%           - x: the matrix of the un-mapped variables
%           - range: the cell array of the integer values for the variables
%           - hot_side: struct containing hot fluid properties 
%           - cold_side: struct containing the cold fluid properties
%           - PHE_properties: struct containing the PHE characteristics
%
% Outputs:  - y: the objectives matrix. Each column array contains the
%           evaluated objectives.
%

[epsilon, delta_p_hot, delta_p_cold, v_hot, v_cold, h_hot, ...
    h_cold, U, A, NTU]=PHE_solve(x, range, hot_side, cold_side, PHE_properties);

y(:,1) = - epsilon; % maximaze effectiveness
y(:,2) = delta_p_hot; % minimize pressure drops
y(:,3) = delta_p_cold;
y(:,4) = A; % minimize total exchange area (PHE dimensions)
end







