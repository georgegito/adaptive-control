function xm_dot = dynamics_model(xm, Am)
    
    xm_dot = Am * xm;
end