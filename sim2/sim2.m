clear;
close all;
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
set(groot, 'defaultFigureUnits', 'points', 'defaultFigurePosition', [20 20 700*1.3 300*1.3]);
set(groot, 'DefaultLineLineWidth', 1);

%% real system
Ap = [  -0.8060       1     ;
            -9.1486   -4.59  ];
Bp = [   -0.04;      -4.59  ];
Cp = [       1;           0     ];

% uncertainties
D =0.5;
ka = -10;
kq = -10;
f = @(xp) ka * xp(1) + kq * xp(2);

%% model
np = length(Ap);

Bm = zeros(np, 1);
Cm = Cp;

%% controller
K = [   3  ;     2   ;   1  ];

%% augmented model
Am_tilde = [0 Cp'; zeros(2, 1) Ap] + [0; Bp] * K';
Bm_tilde = [    -1  ;   Bm  ];
Cm_tilde = [    0   ;  Cm   ];

r = @(t) deg2rad(reference_signal(t));
r2deg = @(t) reference_signal(t);

% augmented model sim
t_span = [0 120];
% t_span = [0 2]; % to show instability of yp
zm0 = [0; 0; 0];

[t, zm] = ode45(@(t, zm) dynamics_aug_model(t, zm, r, Am_tilde, Bm_tilde), t_span, zm0);
ym = Cm_tilde' * zm';

%% augmented real system
Ap_tilde = [    0                   Cp' ;
                    zeros(np, 1)     Ap ];
Bp_tilde = [    0   ;   Bp  ];
Cp_tilde = [    0   ;  Cp   ];

% augmented real system sim
zp0 = [0; 0; 0];

[t, zp] = ode45(@(t, zp) dynamics_aug_real(t, zp, r, Ap_tilde, Bp_tilde, Bm_tilde, K, D, f), t, zp0);
yp = Cp_tilde' * zp';
u = K' * zp';

% plots
figure;
plot(t, rad2deg(yp));
grid on;
xlabel('time (s)');
ylabel('angle (deg)');
legend('$y_p$');

% figure;
% hold on;
% fplot(r2deg, t_span, 'Linewidth', 1);
% plot(t, rad2deg(ym));
% hold off;
% grid on;
% legend('$r$', '$y_m$');

% figure;
% plot(t, rad2deg(yp-ym));
% legend('$e$');

figure;
plot(t, rad2deg(u));
grid on;
xlabel('time (s)');
ylabel('angle (deg)');
legend('$u$');

