h = 0.5;
x = 0:h:2*pi;
y = sin(x);
m = diff(y)./diff(x);
plot(x(1:end-1),m);
