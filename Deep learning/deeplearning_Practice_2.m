imds = imageDatastore('MerchData', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7);

net = googlenet;

% 使用 analyzeNetwork 可以交互可视方式呈现网络架构以及有关网络层的详细信息
analyzeNetwork(net)
net.Layers(1)
inputSize = net.Layers(1).InputSize;
%% 替换最终层
% 网络的卷积层会提取最后一个可学习层和最终分类层用来对输入图像进行分类的图像特征。GoogLeNet 中的 'loss3-classifier' 和 'output' 这两个层包含有关如何将网络提取的特征合并为类概率、损失值和预测标签的信息。
% 要对预训练网络进行重新训练以对新图像进行分类，请将这两个层替换为适合新数据集的新层。

% 将经过训练的网络转换为层图
lgraph = layerGraph(net);

% 查找要替换的两个层的名称。您可以手动执行此操作，也可以使用支持函数 findLayersToReplace 自动查找这两个层
[learnableLayer,classLayer] = findLayersToReplace(lgraph);

% 在大多数网络中，具有可学习权重的最后一层是全连接层。将此全连接层替换为新的全连接层，其中输出数量等于新数据集中类的数量（在此示例中为 5）
numClasses = numel(categories(imdsTrain.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer') % isa()确定输入是否具有指定数据类型
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

% 分类层指定网络的输出类。将分类层替换为没有类标签的新分类层。trainNetwork 会在训练时自动设置层的输出类
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

% 要检查新层是否正确连接，请绘制新的层图并放大网络的最后几层
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])
%% 冻结初始层
% 现在，网络已准备好针对新的图像集进行重新训练。
% 您也可以选择将较浅网络层的学习率设置为零，来“冻结”这些层的权重。
% 在训练过程中，trainNetwork 不会更新已冻结层的参数。由于不需要计算已冻结层的梯度，因此冻结多个初始层的权重可以显著加快网络训练速度。
% 如果新数据集很小，冻结较浅的网络层还可以防止这些层对新数据集过拟合。
% 提取层图的层和连接，并选择要冻结的层。在 GoogLeNet 中，前 10 个层构成了网络的初始"主干"。
% 使用辅助函数 freezeWeights 将前 10 个层的学习率设置为零。
% 使用支持函数 createLgraphUsingConnections 以原始顺序重新连接所有层。
% 新的层图包含相同的层，但较浅层的学习率设置为零。
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);
%% 训练网络
% 网络要求输入图像的大小为 224×224×3，但图像数据存储中的图像具有不同大小。
% 使用增强的图像数据存储可自动调整训练图像的大小。指定要对训练图像执行的附加增强操作：沿垂直轴随机翻转训练图像，以及在水平和垂直方向上随机平移训练图像最多 30 个像素并将训练图像缩放最多 10%。
% 数据增强有助于防止网络过拟合和记忆训练图像的具体细节。
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

% 要在不执行进一步数据增强的情况下自动调整验证图像的大小，请使用增强的图像数据存储，而不指定任何其他预处理操作。
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

% 指定训练选项。将 InitialLearnRate 设置为较小的值以减慢尚未冻结的迁移层中的学习速度。
% 在上一步中，您增大了最后一个可学习层的学习率因子，以加快新的最终层中的学习速度。
% 这种学习率设置组合会加快新层中的学习速度，减慢中间层中的学习速度，停止较浅的冻结层中的学习。
% 指定要训练的轮数。执行迁移学习时，所需的训练轮数相对较少。一轮训练是对整个训练数据集的一个完整训练周期。
% 指定小批量大小和验证数据。每轮计算一次验证准确度。
miniBatchSize = 10;
valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(augimdsTrain,lgraph,options);