function [ dest ] = drawRect( src, pt, wSize,  lineSize, color )
%简介：
% %将图像画上有颜色的框图，如果输入是灰度图，先转换为彩色图像，再画框图
% 图像矩阵
% 行向量方向  是  y
% 列向量方向  是  x
%----------------------------------------------------------------------
%输入：
% src：        原始图像，可以为灰度图，可为彩色图
% pt：         左上角坐标   [x1, y1]
% wSize：   框的大小      [wx, wy]
% lineSize： 线的宽度
% color：     线的颜色      [r,  g,  b] 
%----------------------------------------------------------------------
%输出：
% dest：           画好了的图像
%---------------------------------------------------------------------

%判断框的边界问题
[xA, yA, z] = size(src);
x1 = pt(1);
y1 = pt(2);
wx = wSize(1);
wy = wSize(2);
if  x1>xA || ...
        y1>yA||...
        (x1+wx)>xA||...
        (y1+wy)>yA
    disp('画的框将超过图像 !!!');
    return;
end

%如果是单通道的灰度图，转成3通道的图像
if 1==z
    dest(:, : ,1) = src;
    dest(:, : ,2) = src;
    dest(:, : ,3) = src;
else
    dest = src;
end

%开始画框图
for c = 1 : 3               %3个通道，r，g，b分别画
    for dl = 1 : lineSize   %线的宽度，线条是向外面扩展的
        d = dl - 1;
        dest(  y1-d ,(x1-d):(x1+wx+d) ,c) =  color(c); %上方线条
        dest(  y1+wy+d ,(x1-d):(x1+wx+d),c) =  color(c); %下方线条
        dest(  (y1-d):(y1+wy+d),x1-d ,c) =  color(c); %左方线条
        dest(  (y1-d):(y1+wy+d),x1+wx+d,c) =  color(c); %左方线条
    end    
end 
end 