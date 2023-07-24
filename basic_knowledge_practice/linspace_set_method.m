x = linspace(0,2*pi,1000);  %linspace 类似于冒号运算符“:”，但可以直接控制点数并始终包括端点。
y = sin(x);
plot(x,y);
set(gcf, 'Color', [1 1 1]); %Figure的默认辨识码为gcf,Axes的默认辨识码为gca

