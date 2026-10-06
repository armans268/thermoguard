%% ThermoGuard shared parameters

%% 1. Sourced hardware / material values

Q_base = 125;             % W, Intel Processor Base Power
Q_turbo = 181;            % W, Intel Maximum Turbo Power
Tj_max = 100;             % degC, Intel junction temperature limit

m_heatsink = 0.550;       % kg, Noctua NH-U12S redux heatsink mass

cp_Al = 910;              % J/(kg*K)
cp_Cu = 390;              % J/(kg*K)
cp_Si = 710;              % J/(kg*K)


%% 2. Modelling assumptions

Ta = 25;                  % degC, assumed cooler inlet air temperature

m_cpu = 0.0355;           % kg, assumed effective CPU mass
f_Al = 0.50;              % assumed aluminium mass fraction of heatsink

R_total = 0.31;           % K/W, transferred nominal CPU-to-air resistance
alpha_eh = 0.40;          % fraction assigned to CPU-to-heatsink resistance

R_ha_passive = 0.50;      % K/W, assumed stopped-fan cooling resistance
fan_exponent = 1;         % linear effective cooling model


%% 3. Derived thermal parameters

cp_cpu = (cp_Cu + cp_Si)/2;                     % J/(kg*K)
C_e = m_cpu * cp_cpu;                           % J/K

cp_heatsink = f_Al*cp_Al + (1-f_Al)*cp_Cu;      % J/(kg*K)
C_h = m_heatsink * cp_heatsink;                 % J/K

R_eh = alpha_eh * R_total;                      % K/W
R_ha_maxfan = (1-alpha_eh) * R_total;           % K/W

G_ha_maxfan = 1/R_ha_maxfan;                    % W/K
G_ha_passive = 1/R_ha_passive;                  % W/K


%% 4. Controller parameters

T_set = 85;               % degC

Kp = 0.1;
Ki = 0.0005;

u_min = 0;
u_max = 1;


%% 5. Test scenario

T_e0 = Ta;                % degC
T_h0 = Ta;                % degC

Q_initial = Q_base;       % W
Q_final = Q_turbo;        % W
disturbance_time = 600;   % s