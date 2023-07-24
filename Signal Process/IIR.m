%% IIR 滤波器设计
% FIR 滤波器的缺点之一是它们需要很大的滤波器阶数才能满足某些设计设定。如果波纹保持不变，滤波器阶数与过渡带宽度成反比。通过使用反馈，
% 使用小得多的滤波器阶数即可满足一组设计设定。这就是 IIR 滤波器设计背后的思想。"无限冲激响应" (IIR) 一词源于这样的事实：当冲激施加到滤波器时，
% 输出永远不会衰减到零。
% 当计算资源非常宝贵时，IIR 滤波器非常有用。然而，稳定的因果 IIR 滤波器无法提供完美的线性相位。在要求相位线性的情况下，避免使用 IIR 设计。
% 使用 IIR 滤波器的另一个重要原因是相对于 FIR 滤波器，IIR 滤波器的群延迟较小，从而瞬时响应更短。

%% 巴特沃斯滤波器
% 巴特沃斯滤波器是具有最大平坦度的 IIR 滤波器。通带和阻带中的平坦度导致过渡带非常宽。需要较大的阶数才能获得具有窄过渡带宽度的滤波器。
%设计一个最小阶巴特沃斯滤波器，其通带频率为 100 Hz，阻带频率为 300 Hz，最大通带波纹为 1 dB，阻带衰减为 60 dB。采样率为 2 kHz。

Fp = 100;
Fst = 300;
Ap = 1;
Ast = 60;
Fs = 2e3;

dbutter = designfilt('lowpassiir','PassbandFrequency',Fp,...
  'StopbandFrequency',Fst,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast,'SampleRate',Fs,'DesignMethod','butter');

hfvt = fvtool(dbutter);


% 切比雪夫 I 型滤波器
% 通过允许通带波纹，切比雪夫 I 型滤波器的过渡带宽度小于同阶巴特沃斯滤波器。
% 巴特沃斯和切比雪夫 I 型滤波器都具有最平坦的阻带。对于给定的滤波器阶数，需要在通带波纹和过渡带宽度之间进行权衡。

dcheby1 = designfilt('lowpassiir','PassbandFrequency',Fp,...
  'StopbandFrequency',Fst,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast,'SampleRate',Fs,'DesignMethod','cheby1');

% 切比雪夫 II 型滤波器
% 切比雪夫 II 型滤波器具有最平坦的通带和等波纹阻带。
% 由于通常不需要非常大的衰减，我们可以通过允许一些阻带波纹，以相对较小的阶数获得所需的过渡带宽度。
% 设计一个最小阶切比雪夫 II 型滤波器，其设定与前面示例中相同。
dcheby2 = designfilt('lowpassiir','PassbandFrequency',Fp,...
  'StopbandFrequency',Fst,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast,'SampleRate',Fs,'DesignMethod','cheby2');

% 椭圆滤波器
% 椭圆滤波器通过允许通带和阻带中的波纹来泛化切比雪夫和巴特沃斯滤波器。
% 随着波纹变小,椭圆滤波器可以任意逼近切比雪夫或巴特沃斯滤波器的幅值和相位响应。
% 椭圆滤波器能够以最小的阶数获得给定的过渡带宽度。
dellip = designfilt('lowpassiir','PassbandFrequency',Fp,...
  'StopbandFrequency',Fst,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast,'SampleRate',Fs,'DesignMethod','ellip');

addfilter(hfvt, dcheby1, dcheby2, dellip);

zoom(hfvt,[0 150 -3 2])%放大通带以查看波纹差异。

legend(hfvt,'butter', 'cheby1', 'cheby2', 'ellip')

FilterOrders = [filtord(dbutter) filtord(dcheby1) filtord(dcheby2), filtord(dellip)]

%群延迟比较对于 IIR 滤波器，我们不仅需要考虑波纹/过渡带宽度的权衡，还需要考虑相位失真的程度。
% 我们知道无法在整个奈奎斯特区间内都有线性相位。因此，我们可能想查看相位响应离线性有多远。
% 实现此目的的一个好方法是观察（理想情况下为常量的）群延迟，查看它的平坦度
hfvt = fvtool(dbutter,dcheby1,dcheby2,dellip,'Analysis','grpdelay');
legend(hfvt,'Butterworth', 'Chebyshev Type I',...
  'Chebyshev Type II','Elliptic')