x = 0:0.1:2*pi;
y1 = sin(x);
y2 = exp(-x);
plot(x, y1, '--x', x, y2, ':o');
xlabel('t = 0 to 2\pi');    %横坐标标签
ylabel('values of sin(t) and e^{-x}');  %纵坐标标签
title('Function Plots of sin(t) and e^{-x}');
legend('sin(t)','e^{-x}');



