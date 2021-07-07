function [T1, T2] = VectorTimeCaculate(Ualpha, Ubeta, Udc, Tpwm, N)
% SVPWM，两个相邻电压矢量的作用时间计算
% sqrt(3)/2 = 0.8660, sqrt(3) = 1.7321
X = 1.7321*Tpwm*Ubeta/Udc;
Y = 1.7321*Tpwm/Udc*(0.8660*Ualpha + 0.5*Ubeta);
Z = 1.7321*Tpwm/Udc*(-0.8660*Ualpha + 0.5*Ubeta);

switch N
   case 1
      T1 = Z;
      T2 = Y;
   case 2
      T1 = Y;
      T2 = -X;
   case 3
      T1 = -Z;
      T2 = X;
   case 4
      T1 = -X;
      T2 = Z;
   case 5
      T1 = X;
      T2 = -Y;
   case 6
      T1 = -Y;
      T2 = -Z;
   otherwise
      T1 = 0;
      T2 = 0;
end

if T1 + T2 > Tpwm
    T1 = T1/(T1 + T2)*Tpwm;
    T2 = T2/(T1 + T2)*Tpwm;
end

end

