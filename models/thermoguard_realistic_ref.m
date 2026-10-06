% Verification of realistic Simscape model with calculations

run("../config/thermoguard_parameters.m")

% Thermoguard realistic without controller

tspan = [0 2000];

y0_125W = [T_e0; T_h0];
y0_181W = [T_e0; T_h0];

%% CPU with 125W and 181W power output

% ODE solver

% For 125W
[t,y] = ode45(@(t,y) solveDerivatives125W( ...
    t, y, Ta, Q_initial, R_eh, G_ha_maxfan, C_e, C_h), ...
    tspan, y0_125W);

% For 181W
[t2,y2] = ode45(@(t2,y2) solveDerivatives181W( ...
    t2, y2, Ta, Q_turbo, R_eh, G_ha_maxfan, C_e, C_h), ...
    tspan, y0_181W);

%% Extract temperature vectors

Te_125W = y(:,1);
Th_125W = y(:,2);

Te_181W = y2(:,1);
Th_181W = y2(:,2);

%% Plotting for 125W

figure

plot(t,Te_125W)
hold on
plot(t,Th_125W)

title("Change of Temperature Over Time for 125W")
xlabel("Time in seconds")
ylabel("Temperature in °C")
legend("Temperature of Electronics", "Temperature of Heat sink")
grid on
hold off

%% Plotting for 181W

figure

plot(t2,Te_181W)
hold on
plot(t2,Th_181W)

title("Change of Temperature Over Time for 181W")
xlabel("Time in seconds")
ylabel("Temperature in °C")
legend("Temperature of Electronics", "Temperature of Heat sink")
grid on
hold off

%% Calculate temperatures at steady state

T_h_ss_125W = Ta + Q_initial/G_ha_maxfan;
T_e_ss_125W = T_h_ss_125W + Q_initial*R_eh;

T_h_ss_181W = Ta + Q_turbo/G_ha_maxfan;
T_e_ss_181W = T_h_ss_181W + Q_turbo*R_eh;

%% Solve the thermal equations

function v = solveDerivatives125W(~, y, Ta, Q_initial, R_eh, G_ha_maxfan, C_e, C_h)

Q_eh = (y(1) - y(2))/R_eh;
Q_ha = (y(2) - Ta)*G_ha_maxfan;

dT_e = (Q_initial - Q_eh)/C_e;
dT_h = (Q_eh - Q_ha)/C_h;

v = [dT_e; dT_h];

end

function v = solveDerivatives181W(~, y2, Ta, Q_turbo, R_eh, G_ha_maxfan, C_e, C_h)

Q_eh = (y2(1) - y2(2))/R_eh;
Q_ha = (y2(2) - Ta)*G_ha_maxfan;

dT_e = (Q_turbo - Q_eh)/C_e;
dT_h = (Q_eh - Q_ha)/C_h;

v = [dT_e; dT_h];

end