function zm_dot = dynamics_aug_model(t, zm, r, Am_tilde, Bm_tilde)
    
    zm_dot = Am_tilde * zm + Bm_tilde * r(t);
end