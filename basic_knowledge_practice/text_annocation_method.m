x = linspace(0,3);
y = x.^2.*sin(x);
plot(x,y);
line([2,2],[0,2^2*sin(2)]);
str = '$$ \int_{0}^{2} x^2\sin(x) dx $$';   %\int代表积分符号，从0积到2
text(0.25, 2.5, str,'Interpreter','latex' );
annotation('arrow','X', [0.32,0.5], 'Y', [0.6, 0.4]);   %箭头指示的作用
