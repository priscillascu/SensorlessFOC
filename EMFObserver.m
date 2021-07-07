% 论文New Sliding-Mode Observer for Position Sensorless Control of Permanent-Magnet Synchronous Motor
% 使用反电动势观测器对滑模观测器输出的反电动势观测进行角度解算

function [sys,x0,str,ts] = EMFObserver(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % 调用初始化子函数
  case 1,
    sys=mdlDerivatives(t,x,u);   %调用计算微分子函数
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);    %计算输出子函数
  case 4,
    sys=[];   %计算下一仿真时刻子函数
  case 9,
    sys=[];    %终止仿真子函数
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes   %初始化子函数

sizes = simsizes;

sizes.NumContStates  = 3;  %连续状态变量个数
sizes.NumDiscStates  = 0;  %离散状态变量个数
sizes.NumOutputs     = 4;  %输出变量个数
sizes.NumInputs      = 2;   %输入变量个数
sizes.DirFeedthrough = 0;   %输入信号是否在输出端出现
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [0, 0, 0];   %初始值
str = [];   
ts  = [0 0];   %[0 0]用于连续系统，[-1 0]表示继承其前的采样时间设置
simStateCompliance = 'UnknownSimState';

function sys = mdlDerivatives(t, x, u)    %计算微分子函数
Ea = u(1);
Eb = u(2);
Ea_est = x(1);
Eb_est = x(2);
omega_est = x(3);
L = 5000;  % L = 100，反电动势0.96秒收敛，该值越大收敛越快，但不会影响角速度收敛速度

sys(1) = -omega_est*Eb_est - L*(Ea_est - Ea);
sys(2) = omega_est*Ea_est - L*(Eb_est - Eb);
sys(3) = (Ea_est - Ea)*Eb_est - (Eb_est - Eb)*Ea_est;

function sys=mdlOutputs(t,x,u)   %计算输出子函数
Ea_est = x(1);
Eb_est = x(2);

if Ea_est == 0 && Eb_est == 0
    theta_est = 0;
else
    theta_est = -atan2(Ea_est, Eb_est);
    if theta_est < 0
        theta_est = theta_est + 2*pi;
    else
        theta_est = theta_est;
    end
end

omega_est = sqrt(Ea_est^2 + Eb_est^2)/0.0749697;
sys(1) = theta_est;
sys(2) = omega_est;
sys(3) = Ea_est;
sys(4) = Eb_est;
