%主函数，对输入的图片进行遍历，掩膜大小为128*128
%载入图像
clc;clear;close all;
img_test_gray=imread("Pictures/1033.jpg");%这里的图片可以任意更改
% img_test_gray=rgb2gray(img_test_rgb);
%开始遍历图像
[m,n]=size(img_test_gray);%获取测试图像的长宽信息,这里已知为768*576
SVM_Training_Progress();%通过SVM机器学习方法进行数据训练，并且为特征向量分类
for curr_x=1:16:m-256
    for curr_y=1:16:n-256
        if(curr_y==465)
            break;
        else
        img_t_gray=imcrop(img_test_gray,[curr_x,curr_y,127,127]);
        load svmStruct%载入SVM分类后的结构体  
        hogt =Find_HOG_Vectors(img_t_gray);%计算HOG特征向量
        d=zeros(1,1764);
        for hh=1:49
            z=hogt{1,hh};
            d(1,(36*(hh-1)+1):36*hh)=z;%将每个Cell的值分配到d的向量中
        end
        
        classes_temp = predict(svmStruct,d);%classes的值即为分类结果
        
        if(classes_temp==1)%当检测结果为1，即判断为Pinhole时
            location_of_pinhole=[curr_x,curr_y];%存储位置信息，方便后期画边框
            if(curr_x+64<m-127)
            curr_x=curr_x+64;%在不超出数组边界的情况下将横坐标跳变
            end
            break;
        end
        end
    end
end
%在原RGB图像上画出识别框
img_test_gray=drawRect(img_test_gray,location_of_pinhole,[128,128],2,[0,255,255]);
imshow(img_test_gray);
%在识别出的针孔上方写出名字
text(location_of_pinhole(1),location_of_pinhole(2)-12,'Pinhole','horiz','left','color','b','fontsize',12);

