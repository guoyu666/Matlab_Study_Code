x = -3.5:0.2:3.5;
y = -3.5:0.2:3.5;
[X,Y] = meshgrid(x, y);
Z =  X.*exp(-X.^2-Y.^2);
subplot(1,2,1);
meshc(X,Y,Z);
subplot(1,2,2)
surfc(X,Y,Z);

