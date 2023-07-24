%% 使用长短期记忆网络对 ECG 信号进行分类
% 加载并检查数据
if ~isfile('PhysionetData.mat')
    ReadPhysionetData         
end
load PhysionetData

% 生成信号长度的直方图。大多数信号的长度是 9000 个采样。
L = cellfun(@length,Signals);   % 将函数length应用于元胞数组的每个元胞内容
h = histogram(L);
xticks(0:3000:18000);
xticklabels(0:3000:18000);
title('Signal Lengths')
xlabel('Length')
ylabel('Count')

% 可视化每个类中一个信号的一段。AFib 心跳间隔不规则，而正常心跳会周期性发生。AFib 心跳信号还经常缺失 P 波，P 波在正常心跳信号的 QRS 复合波之前出现。
% 正常信号的绘图会显示 P 波和 QRS 复合波。
normal = Signals{1};
aFib = Signals{4};

subplot(2,1,1)
plot(normal)
title('Normal Rhythm')
xlim([4000,5200])
ylabel('Amplitude (mV)')
text(4330,150,'P','HorizontalAlignment','center')
text(4370,850,'QRS','HorizontalAlignment','center')

subplot(2,1,2)
plot(aFib)
title('Atrial Fibrillation')
xlim([4000,5200])
xlabel('Samples')
ylabel('Amplitude (mV)')

%% 准备要训练的数据
% 在训练期间，trainNetwork 函数将数据分成小批量。然后，该函数在同一个小批量中填充或截断信号，使它们都具有相同的长度。过多的填充或截断会对网络性能产生负面影响，因为网络可能会根据添加或删除的信息错误地解释信号。
% 为避免过度填充或截断，请对 ECG 信号应用 segmentSignals 函数，使它们的长度都为 9000 个采样。该函数会忽略少于 9000 个采样的信号。如果信号的采样超过 9000 个，segmentSignals 会将其分成尽可能多的包含 9000 个采样的信号段，并忽略剩余采样。
% 例如，具有 18500 个采样的信号将变为两个包含 9000 个采样的信号，剩余的 500 个采样被忽略。
[Signals,Labels] = segmentSignals(Signals,Labels);

%% 第一次尝试：使用原始信号数据训练分类器
% 要设计分类器，请使用上一节中生成的原始信号。将信号分成一个训练集（用于训练分类器）和一个测试集（用于基于新数据测试分类器的准确度）。
% 使用 summary 函数显示 AFib 信号与正常信号的比率为 718:4937，约为 1:7。
summary(Labels)

