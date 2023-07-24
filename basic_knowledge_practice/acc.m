function  [a, F] = acc(v2,v1,t2,t1,m)
    %加速度及力的计算
    a = (v2-v1)./(t2-t1);
    F = m.*a;
    