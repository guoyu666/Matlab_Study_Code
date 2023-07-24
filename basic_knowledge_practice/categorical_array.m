%% 基于字符串数组创建分类数组
state = ["MA","ME","CT","VT","ME","NH","VT","MA","NH","CT","RI"]


% 将字符串数组 state 转换为无数学排序的分类数组
state = categorical(state)

categories(state)
%% 添加新元素和缺失的元素
state = ["MA","ME","CT","VT","ME","NH","VT","MA","NH","CT","RI"];
state = [string(missing) state];
state(13) = "ME"

state = categorical(state)
%% 基于字符串数组创建有序分类数组
AllSizes = ["medium","large","small","small","medium",...
            "large","medium","small"];

valueset = ["small","medium","large"];
sizeOrd = categorical(AllSizes,valueset,'Ordinal',true)
% 列出分类变量 sizeOrd 中的离散类别
categories(sizeOrd)
%% 比较分类数组元素
C = {'blue' 'red' 'green' 'blue';...
    'blue' 'green' 'green' 'blue'};

colors = categorical(C)

% 列出分类数组的类别
categories(colors)

colors(1,:) == colors(2,:)

colors == 'blue'

% 转化为有序分类数组
% 对 colors 中的类别添加数学排序。指定表示色谱排序的类别顺序 red < green < blue
colors = categorical(colors,{'red','green' 'blue'},'Ordinal',true)
categories(colors)

colors(:,1) > colors(:,2)

colors < 'blue'
