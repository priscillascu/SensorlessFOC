% ������ģ�۲���

function [sys,x0,str,ts] = BasicSMO(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % ���ó�ʼ���Ӻ���
  case 1,
    sys=mdlDerivatives(t,x,u);   %���ü���΢���Ӻ���
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);    %��������Ӻ���
  case 4,
    sys=[];   %������һ����ʱ���Ӻ���
  case 9,
    sys=[];    %��ֹ�����Ӻ���
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes   %��ʼ���Ӻ���

sizes = simsizes;

sizes.NumContStates  = 2;  %����״̬��������
sizes.NumDiscStates  = 0;  %��ɢ״̬��������
sizes.NumOutputs     = 4;  %�����������
sizes.NumInputs      = 4;   %�����������
sizes.DirFeedthrough = 0;   %�����ź��Ƿ�������˳���
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [0, 0];   %��ʼֵ
str = [];   
ts  = [0 0];   %[0 0]��������ϵͳ��[-1 0]��ʾ�̳���ǰ�Ĳ���ʱ������
simStateCompliance = 'UnknownSimState';
global Valpha;
global Vbeta;
Valpha = 0;
Vbeta = 0;

function sys = mdlDerivatives(t, x, u)    %����΢���Ӻ���
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

function sys=mdlOutputs(t,x,u)   %��������Ӻ���
global Valpha;
global Vbeta;
sys(1) = Valpha;
sys(2) = Vbeta;
sys(3) = x(1);
sys(4) = x(2);

function y = sat(x)
k = 30;
y = (2/(1+exp(-k*x)) - 1);
