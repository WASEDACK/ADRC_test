function [sys,x0,str,ts]=TD(t,x,u,flag,r,h,T)
switch flag,
case 0
   [sys,x0,str,ts] = mdlInitializeSizes; % ��ʼ��
case 2 
   sys = mdlUpdates(x,u,r,h,T);  % ��ɢ״̬�ĸ���
case 3
   sys = mdlOutputs(x); % ������ļ���
case { 1, 4, 9 }
   sys = []; % δʹ�õ�flagֵ
otherwise
   error(['Unhandled flag = ',num2str(flag)]); % �������
end;
%==============================================================
% ��flagΪ0ʱ��������ϵͳ�ĳ�ʼ��
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes
% ���ȵ���simsizes�����ó�ϵͳ��ģ����sizes, ��������ɢϵͳ��ʵ��
% �������sizes����
sizes = simsizes;
sizes.NumContStates = 0;  % ������״̬
sizes.NumDiscStates = 2;  % ����ɢ״̬
sizes.NumOutputs = 2;     % �������Ϊ2
sizes.NumInputs = 1;      % �������Ϊ1
sizes.DirFeedthrough = 0; % ���벻ֱ��������з�ӳ����
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [0; 0]; % ���ó�ʼ״̬Ϊ��״̬
str = []; % ��str��������Ϊ���ַ���
ts = [-1 0]; % ��������: [period, offset] �̳������źŵĲ�������
%==============================================================
% ����������flag=2ʱ��������ɢϵͳ��״̬����
%==============================================================
function sys = mdlUpdates(x,u,r,h,T)
sys(1,1)=x(1)+T*x(2);
sys(2,1)=x(2)+T*fst2(x(1)-u,x(2),r,h);
%==============================================================
% ��������flag=3ʱ������ϵͳ���������
%==============================================================
function sys = mdlOutputs(x)
sys=x; 
%==============================================================
% �û�������Ӻ����� fst2
%==============================================================
function f=fst2(x1,x2,r,h)
d=r*h*h;
a0=h*x2;

y=x1+a0;
a1=sqrt(d*(d+8*abs(y)));
a2=a0+sign(y)*(a1-d)/2;
sy=(sign(y+d)-sign(y-d))/2;
a=(a0+y-a2)*sy+a2;
sa=(sign(a+d)-sign(a-d))/2;
f=-r*(a/d-sign(a))*sa-r*sign(a);



