% ����New Sliding-Mode Observer for Position Sensorless Control of Permanent-Magnet Synchronous Motor
% ʹ�÷��綯�ƹ۲����Ի�ģ�۲�������ķ��綯�ƹ۲���нǶȽ���

function [sys,x0,str,ts] = EMFObserver(t, x, u, flag)
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

sizes.NumContStates  = 3;  %����״̬��������
sizes.NumDiscStates  = 0;  %��ɢ״̬��������
sizes.NumOutputs     = 4;  %�����������
sizes.NumInputs      = 2;   %�����������
sizes.DirFeedthrough = 0;   %�����ź��Ƿ�������˳���
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [0, 0, 0];   %��ʼֵ
str = [];   
ts  = [0 0];   %[0 0]��������ϵͳ��[-1 0]��ʾ�̳���ǰ�Ĳ���ʱ������
simStateCompliance = 'UnknownSimState';

function sys = mdlDerivatives(t, x, u)    %����΢���Ӻ���
Ea = u(1);
Eb = u(2);
Ea_est = x(1);
Eb_est = x(2);
omega_est = x(3);
L = 5000;  % L = 100�����綯��0.96����������ֵԽ������Խ�죬������Ӱ����ٶ������ٶ�

sys(1) = -omega_est*Eb_est - L*(Ea_est - Ea);
sys(2) = omega_est*Ea_est - L*(Eb_est - Eb);
sys(3) = (Ea_est - Ea)*Eb_est - (Eb_est - Eb)*Ea_est;

function sys=mdlOutputs(t,x,u)   %��������Ӻ���
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
