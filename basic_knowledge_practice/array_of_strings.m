%% 访问字符串数组的元素
str = ["Mercury","Gemini","Apollo";
       "Skylab","Skylab B","ISS"];
str(1,:)

str(2,2)

str(3,4) = "Mir"
%% 访问字符串中的字符
% 您可以使用花括号 {} 对字符串数组进行索引以直接访问字符。当您需要访问和修改字符串元素中的字符时，请使用花括号。
% 通过花括号进行索引为可处理字符串数组或字符向量元胞数组的代码提供了兼容性。
% 但是只要有可能，请尽量使用字符串函数来处理字符串中的字符。
str = ["Mercury","Gemini","Apollo";
       "Skylab","Skylab B","ISS"];
chr = str{2,2}
str{2,2}(1:3)
%% 将字符串串联到字符串数组中
str1 = ["Mercury","Gemini","Apollo"];
str2 = ["Skylab","Skylab B","ISS"];
str = [str1 str2]

str1 = str1';
str2 = str2';
str = [str1 str2];
str = [["Mission:","Station:"] ; str]