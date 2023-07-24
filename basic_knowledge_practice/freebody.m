function x = freebody(x0,v0,t)
%自由落体运动的计算公式

x = x0 + v0.*t + 1/2*9.8*t.*t;  %点乘-->对应位置相乘
   