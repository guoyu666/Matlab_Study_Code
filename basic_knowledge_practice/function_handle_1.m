%% 将一个函数传递到另一个函数
a = 0;
b = 5;
q1 = integral(@log,a,b) % 数值积分
q2 = integral(@sin,a,b)
q3 = integral(@exp,a,b)
%%
fun = @(x)x./(exp(x)-1);
q4 = integral(fun,0,Inf)