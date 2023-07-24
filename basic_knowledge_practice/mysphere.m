[x,y,z] = sphere; %[X,Y,Z] = sphere 返回球面的 x、y 和 z 坐标而不对其绘图。
r = 2;
surf(x*r, y*r, z*r);%绘制球面
axis equal

A = 4*pi*r^2;
V = (4/3)*pi*r^3;
