x = 0:0.5:4*pi;
y = sin(x);
h = cos(x);
w = 1./(1+exp(-x));
g = (1/(2*pi*2)^0.5).*exp((-1.*(x-2*pi).^2)./(2*2^2));
plot(x,y,'bd-',x,h,'gp:',x,w,'ro-',x,g,'c^-');
legend('sin(x)','cos(x)','Sidmoid','Gauss function'); %打上标签，方便查看
