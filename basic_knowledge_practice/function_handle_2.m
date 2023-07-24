%% 比较根据命名函数构造的句柄
fun1 = @sin;
fun2 = @sin;
isequal(fun1,fun2)

%% 比较指向匿名函数的句柄
% 与指向命名函数的句柄不同，表示同一个匿名函数的函数句柄不相等
% 之所以将其视为不等，是因为 MATLAB 不能保证非参数变量的冻结值相同。例如，在本例中，A 是一个非参数变量
A = 5;
h1 = @(x)A * x.^2;
h2 = @(x)A * x.^2;
isequal(h1,h2)

% 如果您创建匿名函数句柄的副本，则副本与原始句柄相等
h1 = @(x)A * x.^2;
h2 = h1;
isequal(h1,h2)
%% 比较嵌套函数的句柄
% 根据同一嵌套函数且在对其父函数的同一调用中构建的函数句柄被视为相等
 [h1,h2] = test_eq(4,19,-7)
 isequal(h1,h2)
function [h1,h2] = test_eq(a,b,c)
h1 = @findZ;
h2 = @findZ;

   function z = findZ
   z = a.^3 + b.^2 + c';
   end
end



