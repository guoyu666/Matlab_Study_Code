%% 低通 IIR 滤波器-最平坦设计
Fpass = 100;
Fstop = 150;
Apass = 0.5;
Astop = 65;
Fs = 1e3;

d = designfilt('lowpassiir', ...
  'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
  'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
  'DesignMethod','butter','SampleRate',Fs);

fvtool(d)
%% 高通IIR滤波器-最平坦设计
Fstop = 350;
Fpass = 400;
Astop = 65;
Apass = 0.5;
Fs = 1e3;

d = designfilt('highpassiir','StopbandFrequency',Fstop ,...
  'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
  'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','butter');

fvtool(d)
