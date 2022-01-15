function res = reference_signal(t)

    if 0 <= t && t < 1
        res = 0;
        return;
    elseif 1 <= t && t < 10
        res = 0.5;
        return;
    elseif 10 <= t && t < 22
        res = 0;
        return;
    elseif 22 <= t && t < 32
        res = -0.5;
        return;
    elseif 32 <= t && t < 45
        res = 0;
        return;
    elseif 45 <= t && t < 55
        res = 1;
        return;
    elseif 55 <= t && t < 65
        res = 0;
        return;
    elseif 65 <= t && t < 75
        res = -1;
        return;
    elseif 75 <= t && t < 85
        res = 0;
        return;
    elseif 85 <= t && t < 95
        res = 0.5;
        return;
    elseif 95 <= t
        res = 0;
        return;
    end

end