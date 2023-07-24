x = -3.5:0.2:3.5;
y = -3.5:0.2:3.5;
[X,Y] = meshgrid(x,y);
Z = X.*exp(-X.^2-Y.^2);
subplot(2,1,1);mesh(X,Y,Z);
axis square
subplot(2,1,2);
contour(X,Y,Z);%空间中的Z值是一样的
contourf(Z); %涂上颜色
axis square
