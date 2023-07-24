x = -2:0.005:2;
y = x.^3;
m = diff(y)./diff(x);
m2 = diff(m)./diff(x(1:end-1));

plot(x,y,x(1:end-1),m,x(1:end-2),m2);
xlabel('x','FontSize',18);
ylabel('y','FontSize',18);
legend('f(x) = x.^3','f(x)一阶导数','f(x)二阶导数');
set(gca,'FontSize',18);
