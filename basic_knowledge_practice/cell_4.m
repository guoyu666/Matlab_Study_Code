%% 访问部分元胞的多级索引
myNum = [1, 2, 3];
myCell = {'one', 'two'};
myStruct.Field1 = ones(3);
myStruct.Field2 = 5*ones(5);

C = {myNum, 100*myNum;
     myCell, myStruct}

C{1,2}

C{1,1}(1,2)

C{2,1}{1,2}

C{2,2}.Field2(5,1)

C{2,1}{2,2} = {pi, eps}
C{2,2}.Field3 = struct('NestedField1', rand(3), ...
                       'NestedField2', magic(4), ...
                       'NestedField3', {{'text'; 'more text'}} )