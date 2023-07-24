%% 重构和重新排列数组
A = [1 4 7 10; 2 5 8 11; 3 6 9 12]

B = reshape(A,2,6)

C = reshape(A,2,2,3)
%% 转置和翻转
A = magic(3)

B = A.'
% 类似的运算符 ' 可以计算复矩阵的共轭转置。此操作计算每个元素的复共轭并对其进行转置。创建一个 2×2 复矩阵并计算其共轭转置。
A = [1+i 1-i; -i i]
B = A'
%% 排序
% sort 函数可以按升序或降序对矩阵的每一行或每一列中的元素进行排序。创建矩阵 A，并按升序对 A 的每一列进行排序。
A = magic(4)
B = sort(A)

% 按降序对每一行进行排序。第二个参数值 2 指定您希望逐行排序。
C = sort(A,2,'descend')
