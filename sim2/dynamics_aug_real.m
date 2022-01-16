function zp_dot = dynamics_aug_real(t, zp, r, Ap_tilde, Bp_tilde, Bm_tilde, K, D, f)
    
    zp_dot = Ap_tilde * zp + Bp_tilde * D * (K' * zp + f(zp(2:3))) + Bm_tilde * r(t);
end