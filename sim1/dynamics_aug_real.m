function zp_dot = dynamics_aug_real(t, zp, r, Ap_tilde, Bp_tilde, Bm_tilde, K)
    
    zp_dot = (Ap_tilde + Bp_tilde * K') * zp + Bm_tilde * r(t);
end