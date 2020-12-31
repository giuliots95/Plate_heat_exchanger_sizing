function Pr = Prandtl(cp,mu, k_fluid)
% This function calsulates the Prandtl number for a given fluid. 
% The Pr is defined as the ratio of momentum diffusivity to thermal 
% diffusivity. 
%   Prandtl number is given by the formula
%   Pr = cp * mu / k
%   Where cp is the specific heat [J/Kg*K], mu is the dynamic viscosity
%   expressed in [Pa*s] and k is the fluid thermal conductivity [W/m*K].
%
% common values are for example 0.6~0.7 for air, 7.2~14.1 for water.
Pr = cp.*mu./k_fluid;
end

