function states_dot = dynamics(t, states, r, Ap_tilde, Bp_tilde, Bm_tilde, D, f, Gk, Gtheta, P, Am_tilde)

    zp = states(1:3);
    K_hat = states(4:6);
    theta_hat = states(7:8);
    zm = states(9:11);

    % model
    zm_dot = Am_tilde * zm + Bm_tilde * r(t);
    
    % adaptive laws
    K_hat_dot = -Gk * zp * (zp - zm)' * P * Bp_tilde;
    theta_hat_dot =  Gtheta * [zp(2); zp(3)] * (zp - zm)' * P * Bp_tilde;
    
    % plant
    zp_dot = Ap_tilde * zp + Bp_tilde * D * ((K_hat' * zp - theta_hat' * [zp(2); zp(3)]) + f(zp(2:3))) + Bm_tilde * r(t);
    
    states_dot = [zp_dot; K_hat_dot; theta_hat_dot; zm_dot];
end