%% 加载相机和预训练网络
camera = webcam;  % Connect to the camera
net = googlenet; % Load the neural network
%% 对相机快照进行分类
% 要对图像进行分类，必须将其大小调整为网络的输入大小。
% 获取网络的图像输入层的 InputSize 属性的前两个元素。图像输入层是网络的第一层。
inputSize = net.Layers(1).InputSize(1:2)

% 实时显示来自相机的图像以及预测的标签及其概率。在调用 classify 之前，必须将图像大小调整为网络的输入大小。
h = figure
while ishandle(h)
    im = snapshot(camera);
    image(im)
    im = imresize(im,inputSize);
    [label,score] = classify(net,im);
    title({char(label),num2str(max(score),2)});
    drawnow
end



