function [c, c_eq] = PHE_nlinconstraint(x, range, hot_side, cold_side,...
    PHE_properties, velocity_boundaries, max_pressure_drops_constraint,...
    efficiency_boundaries)
% This function handles the non-linear constraints to be passed to the
% solver.
%
% Inputs:
%           - x: the matrix of the un-mapped variables
%           - range: the cell array of the integer values for the variables
%           - hot_side: struct containing hot fluid properties 
%           - cold_side: struct containing the cold fluid properties
%           - PHE_properties: struct containing the PHE characteristics
%           - velocity_boundaries: 1 x 2 array containing the lower and
%           upper values for the fluid velocity, both for the cold and for
%           the hot side of the PHE
%           - max_pressure_drops_constraint: 1 x 2 array containing the max
%           pressure drop separately for the cold and hot side.
%           - efficiency_boundaries: 1 x 2 array containing the lower and
%           upper effectiveness admitted for the designs.
%
% Outputs:
%           - c: the inequality matrix to be passed to the optimizer
%           - c_eq: the equality matrix (always empty)
%
%% call the solver function
[epsilon, delta_p_hot, delta_p_cold, v_hot, v_cold, h_hot, ...
    h_cold, U, A, NTU]=PHE_solve(x, range, hot_side, cold_side, PHE_properties);

%% implement boundaries on max and min fluid velocities through the channels
if ismatrix(velocity_boundaries) && ~isempty(velocity_boundaries)
    if isscalar(velocity_boundaries(1)) && ~isnan(velocity_boundaries(1))
        c(:,1) = velocity_boundaries(1) - v_hot; 
        c(:,3) = velocity_boundaries(1) - v_cold; 
   end
    if isscalar(velocity_boundaries(2)) && ~isnan(velocity_boundaries(2))
        c(:,2) =  v_hot - velocity_boundaries(2); 
        c(:,4) =  v_cold - velocity_boundaries(2);
    end
end

% boundaries on max pressure drops on hot and cold side of PHE
if ismatrix(max_pressure_drops_constraint) && ~isempty(max_pressure_drops_constraint)
    if isscalar(max_pressure_drops_constraint(1)) && ~isnan(max_pressure_drops_constraint(1))
        c(:,5) = delta_p_hot -  max_pressure_drops_constraint(1) ; 
   end
    if isscalar(max_pressure_drops_constraint(2)) && ~isnan(max_pressure_drops_constraint(2))
        c(:,6) =  delta_p_cold - max_pressure_drops_constraint(2); 
    end
end
% boundaries on the effectiveness objective
if ismatrix(efficiency_boundaries) && ~isempty(efficiency_boundaries)
    if isscalar(efficiency_boundaries(1)) && ~isnan(efficiency_boundaries(1))
        c(:,7) = efficiency_boundaries(1) - epsilon; 
   end
    if isscalar(efficiency_boundaries(2)) && ~isnan(efficiency_boundaries(2))
        c(:,8) = epsilon - efficiency_boundaries(2); 
    end
end

c_eq=[];
% no equalities as constraints for this problem
end

