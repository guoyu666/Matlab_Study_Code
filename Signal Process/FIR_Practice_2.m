%% 低通 FIR 滤波器-等波纹设计
Fpass = 100;
Fstop = 150;
Apass = 1;
Astop = 65;
Fs = 1e3;

d = designfilt('lowpassfir', ...
  'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
  'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
  'DesignMethod','equiripple','SampleRate',Fs);

fvtool(d)
%% 通带和阻带之间的波纹
N = 8;
Fpass = 100;
Apass = 0.5;
Astop = 65;
Fs = 1e3;

d = designfilt('lowpassiir', ...
  'FilterOrder',N, ...  
  'PassbandFrequency',Fpass, ...
  'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
  'SampleRate',Fs);

fvtool(d)
%% 高通FIR滤波器-等波纹设计
Fstop = 350;
Fpass = 400;
Astop = 65;
Apass = 0.5;
Fs = 1e3;

d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
  'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
  'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');

fvtool(d)
%% 通带和阻带之间的波纹
N = 8;
Fpass = 400;
Astop = 65;
Apass = 0.5;
Fs = 1e3;

d = designfilt('highpassiir', ...
  'FilterOrder',N, ...  
  'PassbandFrequency',Fpass, ...
  'StopbandAttenuation',Astop,'PassbandRipple',Apass, ...
  'SampleRate',Fs);

fvtool(d)
%% 带通FIR滤波器-等波纹设计
Fstop1 = 150;
Fpass1 = 200;
Fpass2 = 300;
Fstop2 = 350;
Astop1 = 65;
Apass  = 0.5;
Astop2 = 65;
Fs = 1e3;

d = designfilt('bandpassfir', ...
  'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
  'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
  'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
  'StopbandAttenuation2',Astop2, ...
  'DesignMethod','equiripple','SampleRate',Fs);

fvtool(d)
%% 任意幅值 FIR 滤波器-单频带任意幅值设计
N = 300;

% Frequencies are in normalized units
F1 = 0:0.01:0.18;
F2 = [.2 .38 .4 .55 .562 .585 .6 .78];
F3 = 0.79:0.01:1;
FreqVect = [F1 F2 F3]; % vector of frequencies

% Define desired response using linear units
A1 = .5+sin(2*pi*7.5*F1)/4;    % Sinusoidal section
A2 = [.5 2.3 1 1 -.2 -.2 1 1]; % Piecewise linear section
A3 = .2+18*(1-F3).^2;          % Quadratic section
z
AmpVect = [A1 A2 A3];

d = designfilt('arbmagfir',...
  'FilterOrder',N,'Amplitudes',AmpVect,'Frequencies',FreqVect,...
  'DesignMethod','freqsamp');

fvtool(d,'MagnitudeDisplay','Zero-phase')
