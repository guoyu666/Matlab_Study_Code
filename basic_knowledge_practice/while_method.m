n=1;
while prod(1:n)< 1e100  %数组元素的乘积什么时候小于10^100次方（等价于n!<10^100次方）
    n = n+1;
end
disp(n)