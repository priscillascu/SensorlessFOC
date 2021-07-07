function [pwm1H, pwm1L, pwm2H, pwm2L, pwm3H, pwm3L] = PWMGen(Tcm1, Tcm2, Tcm3, trig)
% SVPWM，pwm波产生函数，trig为三角波信号
if trig - Tcm1 >= 0
    pwm1H = 1;
    pwm1L = 0;
else
    pwm1H = 0;
    pwm1L = 1;
end

if trig - Tcm2 >= 0
    pwm2H = 1;
    pwm2L = 0;
else
    pwm2H = 0;
    pwm2L = 1;
end

if trig - Tcm3 >= 0
    pwm3H = 1;
    pwm3L = 0;
else
    pwm3H = 0;
    pwm3L = 1;
end

end

