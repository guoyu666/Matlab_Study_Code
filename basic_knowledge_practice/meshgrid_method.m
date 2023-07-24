[x, y] = meshgrid(-3:.2:3,-3:.2:3);
z = x.^2 + x.*y + y.^2;
surf(x,y,z);
box on;
set(gca,'Fontsize',16); zlabel('z');
xlim([-4 4]); xlabel('x'); ylim([-4 4]); ylabel('y');
figure;
imagesc(z); axis square;
xlabel('x');
ylabel('y');
colormap(hot);
colorbar;%代表Z轴的深度
