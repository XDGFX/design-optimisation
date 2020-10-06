function [data] = iter_solver(data, tip_speed_ratio, blade_r, angle_of_attack, chord_distribution, number_blades, C_L_lookup)
% iter_solver
% Calculate Inflow Angle, Axial Induction Factor, and Angular Induction Factor
% for given input parameters of a wind turbine system.
% 
% Callum Morrison, 2020

local_speed_ratio = tip_speed_ratio * (blade_r / max(blade_r));
data.inflow_angle = atan((1 - data.axial_induction_factor) ./ (local_speed_ratio' .* (1 + data.angular_induction_factor)));

pitch_angle = data.inflow_angle - angle_of_attack;

% Find coefficient of lift and drag from aerofoil lookup table
reynolds = 100000;

C_L = interp2(C_L_lookup.reynolds, C_L_lookup.angle_of_attack, C_L_lookup.C_L, reynolds, angle_of_attack);
C_D = 0.1;

blade_solidarity = number_blades .* chord_distribution ./ (2 * pi * blade_r);

C_x = C_L .* sin(data.inflow_angle) + C_D .* cos(data.inflow_angle);
C_theta = C_L .* cos(data.inflow_angle) - C_D .* sin(data.inflow_angle);

data.axial_induction_factor = 1 ./ (( 4 .* sin(data.inflow_angle).^2 ) ./ ( blade_solidarity' .* C_x ) + 1);
data.angular_induction_factor = 1 ./ (4 .* sin(data.inflow_angle) .* cos(data.inflow_angle) ./ (blade_solidarity' .* C_theta) - 1);
end

