n=64;
key=0.512;
an=linspace(3.1,3.99,4000);
hold on;box on;axis([min(an),max(an),-1,2]);
N=n^2;
xn=zeros(1,N);
for a=an
    x = key;
for k=1:20
    x=a*x*(1-x);    %产生公式
end
for k=1:N
    x=a*x*(1-x);
    xn(k)=x;
    b(k,1)=x;   %一维矩阵记录迭代结果
end
plot(a*ones(1,N),xn,'k.','markersize',1);
end
figure
imhist(b)