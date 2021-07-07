% 基础滑模观测器

function [sys,x0,str,ts] = BasicSMO(t, x, u, flag)
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

sizes.NumContStates  = 2;  %连续状态变量个数
sizes.NumDiscStates  = 0;  %离散状态变量个数
sizes.NumOutputs     = 4;  %输出变量个数
sizes.NumInputs      = 4;   %输入变量个数
sizes.DirFeedthrough = 0;   %输入信号是否在输出端出现
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [0, 0];   %初始值
str = [];   
ts  = [0 0];   %[0 0]用于连续系统，[-1 0]表示继承其前的采样时间设置
simStateCompliance = 'UnknownSimState';
global Valpha;
global Vbeta;
Valpha = 0;
Vbeta = 0;

function sys = mdlDerivatives(t, x, u)    %计算微分子函数
global Valpha;
global Vbeta;
ialphaFBK = u(1);
ibetaFBK = u(2);
ualphaFBK = u(3);
ubetaFBK = u(4);
Rs = 26;
Ls = 0.0345;


ialphaEST = x(1);
ibetaEST = x(2);

salpha = ialphaEST - ialphaFBK;
sbeta = ibetaEST - ibetaFBK;

k = 100;
Valpha = k*sat(salpha);
Vbeta = k*sat(sbeta);

sys(1) = -Rs/Ls*ialphaEST + ualphaFBK/Ls - Valpha/Ls;
sys(2) = -Rs/Ls*ibetaEST + ubetaFBK/Ls - Vbeta/Ls;

function sys=mdlOutputs(t,x,u)   %计算输出子函数
global Valpha;
global Vbeta;
sys(1) = Valpha;
sys(2) = Vbeta;
sys(3) = x(1);
sys(4) = x(2);

function y = sat(x)
k = 30;
y = (2/(1+exp(-k*x)) - 1);
