%% 将元胞数组的内容传递给函数
randCell = {'Random Data', rand(20,2)};
plot(randCell{1,2})
title(randCell{1,1})

figure
plot(randCell{1,2}(:,1))    % 仅绘制数据的第一列
title('First Column of Data')

%% 使用 cell2mat 合并多个元胞中的数值数据
temperature(1,:) = {'2020-01-01', [45, 49, 0]};
temperature(2,:) = {'2020-04-03', [54, 68, 21]};
temperature(3,:) = {'2020-06-20', [72, 85, 53]};
temperature(4,:) = {'2020-09-15', [63, 81, 56]};
temperature(5,:) = {'2020-12-31', [38, 54, 18]};

allTemps = cell2mat(temperature(:,2));
dates = datetime(temperature(:,1));

plot(dates, allTemps)
%% 将多个元胞的内容作为以逗号分隔的列表传递给函数
X = -pi:pi/10:pi;
Y = tan(sin(X)) - sin(tan(X));

C(:,1) = {'LineWidth'; 2};
C(:,2) = {'MarkerEdgeColor'; 'k'};
C(:,3) = {'MarkerFaceColor'; 'g'};

plot(X, Y, '--rs', C{:})