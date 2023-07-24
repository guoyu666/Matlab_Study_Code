% 将信号与不同开始时间对齐
% 许多测量涉及多个传感器异步采集的数据。如果您要集成信号，您必须同步它们。Signal Processing Toolbox™ 提供的一些函数可实现此目的。
% 例如，假设有一辆汽车经过一座桥。它产生的振动由位于不同位置的三个相同传感器进行测量。信号有不同到达时间。
% 将信号加载到 MATLAB® 工作区并进行绘图。


load relatedsig

ax(1) = subplot(3,1,1);
plot(s1)
ylabel('s_1')

ax(2) = subplot(3,1,2);
plot(s2)
ylabel('s_2')

ax(3) = subplot(3,1,3);
plot(s3)
ylabel('s_3')
xlabel('Samples')

linkaxes(ax,'x')

t21 = finddelay(s2,s1)
t31 = finddelay(s3,s1)
t32 = finddelay(s2,s3)

% 通过保持最早的信号不动并截除其他向量中的延迟来对齐信号。滞后需要加 1，因为 MATLAB® 使用从 1 开始的索引。
% 此方法使用最早的信号到达时间（即 s2 的到达时间）作为基准来对齐信号
axes(ax(1))
plot(s1(t21+1:end))

axes(ax(2))
plot(s2)

axes(ax(3))
plot(s3(t32+1:end))