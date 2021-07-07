function [Tcm1, Tcm2, Tcm3] = SwitchPoint(N, T1, T2, Tpwm)
% SVPWM，矢量电压时间切换点计算
Ta = (Tpwm - T1 - T2)/4;
Tb = Ta + T1/2;
Tc = Tb + T2/2;

switch N
    case 1
        Tcm1 = Tb;
        Tcm2 = Ta;
        Tcm3 = Tc;
    case 2
        Tcm1 = Ta;
        Tcm2 = Tc;
        Tcm3 = Tb;
    case 3
        Tcm1 = Ta;
        Tcm2 = Tb;
        Tcm3 = Tc;
    case 4
        Tcm1 = Tc;
        Tcm2 = Tb;
        Tcm3 = Ta;
    case 5
        Tcm1 = Tc;
        Tcm2 = Ta;
        Tcm3 = Tb;
    case 6
        Tcm1 = Tb;
        Tcm2 = Tc;
        Tcm3 = Ta;
    otherwise
        Tcm1 = 0;
        Tcm2 = 0;
        Tcm3 = 0;
end

end

