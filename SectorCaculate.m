function [N] = SectorCaculate(Ualpha, Ubeta)
% SVPWMÉÈÇøÅĞ¶Ïº¯Êı
% sqrt(3)/2 = 0.8660, sqrt(3) = 1.7321
Uref1 = Ubeta;
Uref2 = 0.8660*Ualpha - 0.5*Ubeta;
Uref3 = -0.8660*Ualpha - 0.5*Ubeta;

if Uref1 > 0
    A = 1;
else
    A = 0;
end

if Uref2 > 0
    B = 1;
else
    B = 0;
end

if Uref3 > 0
    C = 1;
else
    C = 0;
end

N = 4*C + 2*B + A;
end

