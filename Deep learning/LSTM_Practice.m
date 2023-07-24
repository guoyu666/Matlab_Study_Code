%% 使用深度学习进行时间序列预测
% LSTM 网络是一种循环神经网络 (RNN)，它通过遍历时间步并更新 RNN 状态来处理输入数据。
% RNN 状态包含在所有先前时间步中记住的信息。
% 您可以使用 LSTM 神经网络，通过将先前的时间步作为输入来预测时间序列或序列的后续值

% 要为时间序列预测训练 LSTM 神经网络，请训练具有序列输出的回归 LSTM 神经网络，其中响应（目标）是将值移位了一个时间步的训练序列。
% 也就是说，在输入序列的每个时间步，LSTM 神经网络都学习预测下一个时间步的值
%% 加载数据
% 从 WaveformData.mat 加载示例数据。数据是序列的 numObservations×1 元胞数组，其中 numObservations 是序列数。
% 每个序列都是一个 numChannels × numTimeSteps 数值数组，其中 numChannels 是序列的通道数，numTimeSteps 是序列的时间步数
load WaveformData

% 查看前几个序列的大小
data(1:5)

% 查看通道数。为了训练 LSTM 神经网络，每个序列必须具有相同数量的通道
numChannels = size(data{1},1)

% 可视化绘图中的前几个序列
figure
tiledlayout(2,2)    % 创建分块图布局
for i = 1:4
    nexttile        % 在分块图布局中创建坐标区
    stackedplot(data{i}')

    xlabel("Time Step")
end

% 将数据划分为训练集和测试集。将 90% 的观测值用于训练，其余的用于测试
numObservations = numel(data);
idxTrain = 1:floor(0.9*numObservations);
idxTest = floor(0.9*numObservations)+1:numObservations;
dataTrain = data(idxTrain);
dataTest = data(idxTest);
%% 准备要训练的数据
% 要预测序列在将来时间步的值，请将目标指定为将值移位了一个时间步的训练序列。
% 也就是说，在输入序列的每个时间步，LSTM 神经网络都学习预测下一个时间步的值。预测变量是没有最终时间步的训练序列。
for n = 1:numel(dataTrain)
    X = dataTrain{n};
    XTrain{n} = X(:,1:end-1);   % 预测变量
    TTrain{n} = X(:,2:end);     % 目标值
end

% 为了更好地拟合并防止训练发散，请将预测变量和目标值归一化为零均值和单位方差。在进行预测时，还必须使用与训练数据相同的统计量对测试数据进行归一化。
% 要轻松计算所有序列的均值和标准差，请在时间维度中串联这些序列。
muX = mean(cat(2,XTrain{:}),2); % cat(2,A)水平串联矩阵;mean(A,2)包含每一行均值的列向量
sigmaX = std(cat(2,XTrain{:}),0,2); % std(A,0,2)包含每一行的标准差的列向量

muT = mean(cat(2,TTrain{:}),2);
sigmaT = std(cat(2,TTrain{:}),0,2);

for n = 1:numel(XTrain) % 归一化为零均值和单位方差
    XTrain{n} = (XTrain{n} - muX) ./ sigmaX;
    TTrain{n} = (TTrain{n} - muT) ./ sigmaT;
end
%% 定义 LSTM 神经网络架构
% 创建一个 LSTM 回归神经网络。
% 使用输入大小与输入数据的通道数匹配的序列输入层。
% 接下来，使用一个具有 128 个隐藏单元的 LSTM 层。隐藏单元的数量确定该层学习了多少信息。使用更多隐藏单元可以产生更准确的结果，但也更有可能导致训练数据过拟合。
% 要输出通道数与输入数据相同的序列，请包含一个输出大小与输入数据通道数匹配的全连接层。
% 最后，包括一个回归层。
layers = [
    sequenceInputLayer(numChannels)
    lstmLayer(128)
    fullyConnectedLayer(numChannels)
    regressionLayer];
%% 指定训练选项
% 使用 Adam 优化进行训练。
% 进行 200 轮训练。对于较大的数据集，您可能不需要像良好拟合那样进行这么多轮训练。
% 在每个小批量中，对序列进行左填充，使它们具有相同的长度。左填充可以防止 RNN 预测序列末尾的填充值。
% 每轮训练都会打乱数据。
% 在绘图中显示训练进度。
% 禁用详细输出。
options = trainingOptions("adam", ...
    MaxEpochs=200, ...
    SequencePaddingDirection="left", ...
    Shuffle="every-epoch", ...
    Plots="training-progress", ...
    Verbose=0);
%% 训练循环神经网络
net = trainNetwork(XTrain,TTrain,layers,options);