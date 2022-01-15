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

%% augmented model
Am_tilde = [      0                         1                         0     ;
                     -0.12                    -0.886                   0.96  ;
                    -13.77                  -18.3286              -9.18  ];
Bm_tilde = [    -1  ;   Bm  ];
Cm_tilde = [    0   ;  Cm   ];

r = @(t) deg2rad(reference_signal(t));
r2deg = @(t) reference_signal(t);

%% augmented real system
Ap_tilde = [    0                   Cp' ;
                    zeros(np, 1)     Ap ];
Bp_tilde = [    0   ;   Bp  ];
Cp_tilde = [    0   ;  Cp   ];

Gk = 5000000 * eye(3);
Gtheta =  10000000 * eye(2);
P =  lyap(Am_tilde', eye(3));
 
%% sim
zp0 = [0; 0; 0];
K_hat0 = [0; 0; 0];
theta_hat0 = [0; 0];
zm0 = [0; 0; 0];
states0 = [zp0; K_hat0; theta_hat0; zm0];
t_span = [0 120];

[t, states] = ode45(@(t, states) dynamics(t, states, r, Ap_tilde, Bp_tilde, Bm_tilde, D, f, Gk, Gtheta, P, Am_tilde), t_span, states0);
zp = states(:, 1:3);
K_hat = states(:, 4:6);
theta_hat = states(:, 7:8);
zm = states(:, 9:11);
yp = Cp_tilde' * zp';
ym = Cm_tilde' * zm';

u = zeros(length(t), 1);
for i = 1: length(t)
    u(i) = K_hat(i, :) * zp(i, :)' - theta_hat(i, :) * [zp(i, 2); zp(i,3)];
end

% plots
figure;
hold on;
fplot(r2deg, t_span, 'Linewidth', 1);
plot(t, rad2deg(ym));
plot(t, rad2deg(yp), '--');
hold off;
grid on;
xlabel('time (s)');
ylabel('angle (deg)');
legend('$r$', '$y_m$', '$y_p$');
% 
% figure;
% hold on;
% plot(t,rad2deg(zm(:, 1)));
% plot(t, rad2deg(zm(:, 2:3)));
% plot(t,rad2deg(zp(:, 1)), '--');
% plot(t, rad2deg(zp(:, 2:3)), '--');
% hold off;
% grid on;
% xlabel('time (s)');
% legend('$e_{y_mI} (deg \cdot s)$', '$x_{m_1} (deg)$', '$x_{m_2} (deg)$', '$e_{y_pI} (deg \cdot s)$', '$x_{p_1} (deg)$', '$x_{p_2} (deg)$');
 
figure;
plot(t, K_hat);
grid on;
xlabel('time (s)');
legend('$\hat{K}_1$', '$\hat{K}_2$', '$\hat{K}_3$');

figure;
plot(t, theta_hat);
grid on;
xlabel('time (s)');
legend('$\hat{\theta}_1$', '$\hat{\theta}_2$');
% 
% % figure;
% % plot(t, rad2deg(yp-ym));
% % legend('$e$');
% 
% figure;
% plot(t, rad2deg(u));
% legend('$u$');
% xlabel('time (s)');
% ylabel('angle (deg)');
