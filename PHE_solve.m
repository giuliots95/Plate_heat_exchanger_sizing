function [epsilon, delta_p_hot, delta_p_cold, v_hot, v_cold, h_hot, ...
    h_cold, U, A, NTU] = PHE_solve(x, range, hot_side, cold_side, PHE_properties)
% This function calculates heat exchanger performance in terms of pressure
% drops, overall heat exchange coefficient and exchange area, for given
% inputs.
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
%
% Outputs:
%           - epsilon: heat exchanger effectiveness
%           - delta_p_hot: pressure drop (Pa) on the hot side
%           - delta_p_cold: pressure drop (Pa) on the cold side
%           - v_hot: fluid channel velocity (m/s) for the hot side
%           - v_cold: fluid channel velocity (m/s) for the cold side
%           - h_hot: advective coefficient (W/m^2*°C) for the hot side
%           - h_cold: advective coefficient (W/m^2*°C) for the cold side
%           - U: overall heat exchenge coefficien (W/m^2*°C)
%           - A: PHE global exchange area (m^2)
%           - NTU: number of transfer units (dimensionless)
%
% assign the discrete values to the variables
x_mapped=map_variables(x, range);
w = x_mapped(:,1);
L = x_mapped(:,2);
Fi = x_mapped(:,3);
b = x_mapped(:,4);
n_plates = x_mapped(:,5);
t = x_mapped(:,6);
[n_ch_hot, n_ch_cold] = PHE_channels(n_plates);
%% evaluate C_r
C_hot=hot_side.m_dot.*hot_side.cp;
C_cold=cold_side.m_dot.*cold_side.cp;
C_r=min([C_hot, C_cold])./(max([C_hot, C_cold]));
%% hydraulic diameter
D_eq=4*b.*w./(2*(b+w.*Fi));
%% convective coefficient hot side
v_hot=hot_side.m_dot./(hot_side.rho.*b.*w.*n_ch_hot); 
Re_hot=hot_side.rho*v_hot.*D_eq./hot_side.mu; 
Pr_hot=Prandtl(hot_side.cp, hot_side.mu, hot_side.k_fluid);   
Nu_hot=PHE_Nusselt(Re_hot, Pr_hot);
h_hot=Nu_hot.*hot_side.k_fluid./D_eq;              
%% convective coefficient cold side
v_cold=cold_side.m_dot./(cold_side.rho.*b.*w.*n_ch_cold); 
Re_cold=cold_side.rho*v_cold.*D_eq/cold_side.mu;
Pr_cold=Prandtl(cold_side.cp, cold_side.mu, cold_side.k_fluid); 
Nu_cold=PHE_Nusselt(Re_cold, Pr_cold);
h_cold=Nu_cold.*hot_side.k_fluid./D_eq;
%% overall heat exchange coefficient and area
U=(1./h_hot+t./PHE_properties.k_plate+1./h_cold+hot_side.r_fouling+cold_side.r_fouling).^(-1);
A=n_plates.*w.*L.*Fi;
NTU=U.*A./min([C_hot, C_cold]);
%% pressure drops
f_hot=arrayfun(@colebrook, Re_hot, PHE_properties.roughness./D_eq);
delta_p_hot=(1./D_eq).*f_hot*0.5*hot_side.rho.*v_hot.^2.*L.*n_ch_hot;
f_cold=arrayfun(@colebrook, Re_cold, PHE_properties.roughness./D_eq);
delta_p_cold=(1./D_eq).*f_cold*0.5*cold_side.rho.*v_cold.^2.*L.*n_ch_cold;
%% effectiveness
epsilon=effectiveness(NTU, C_r, PHE_properties.flow_direction,[]);
end

