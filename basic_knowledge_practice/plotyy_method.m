x = 0:0.01:20;
y1 = 200*exp(-0.05*x).*sin(x);
yyaxis left
plot(x,y1);
grid on;
y2 = 0.8*exp(-0.5*x).*sin(10*x);
yyaxis right
plot(x,y2);
title('Labeling plotyy');

