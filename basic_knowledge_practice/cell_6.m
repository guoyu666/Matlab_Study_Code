%% 结构体数组
patient(1).name = 'John Doe';
patient(1).billing = 127.00;
patient(1).test = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];

patient(2).name = 'Ann Lane';
patient(2).billing = 28.50;
patient(2).test = [68, 70, 68; 118, 118, 119; 172, 170, 169];

patient

% 为每位患者的测试结果创建一个条形图
numPatients = numel(patient);
for p = 1:numPatients
   figure
   bar(patient(p).test)
   title(patient(p).name)
   xlabel('Test')
   ylabel('Result')
end