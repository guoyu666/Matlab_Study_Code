x = 0:pi/10:pi;
y=sin(x);
fid = fopen('sinx.txt','w'); %打开文件
for i = 1:11
    fprintf(fid, '%4.2f %4.2f\n', x(i), y(i)); %写入数据
end
fclose(fid); %关闭文档
type sinx.txt  %查看文件里的内容
