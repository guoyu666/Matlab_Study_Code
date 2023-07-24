% 在数据中查找峰值
% 使用 findpeaks 函数求出一组数据中局部最大值的值和位置。
% 文件 spots_num 包含从 1749 年到 2012 年每年观测到的太阳黑子的平均数量。求出最大值及其出现的年份。将它们与数据一起绘制出来。

load("spots_num")

[pks,locs] = findpeaks(avSpots);

plot(year,avSpots,year(locs),pks,"o")
xlabel("Year")
ylabel("Sunspot Number")
axis tight

%% 
%一些峰值彼此非常接近。有些峰值不会周期性重复出现。每 50 年大约有五个这样的峰值。
%为了更好地估计周期持续时间，请再次使用 findpeaks，但这次将峰间间隔限制为至少六年。计算最大值之间的间隔均值。
load("spots_num")
[pks,locs] = findpeaks(avSpots,MinPeakDistance=6);

plot(year,avSpots,year(locs),pks,"o")
xlabel("Year")
ylabel("Sunspot Number")
axis tight
legend(["Data" "peaks"],Location="NorthWest")

meanCycle = mean(diff(locs))    %计算最大值之间的间隔均值
