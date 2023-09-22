%%采用支持向量机的机器学习算法对图像进行二分类，实现区分背景与针头
function svmStruct=SVM_Training_Progress()
%% 训练阶段     
ReadList1  = textread('pos_list.txt','%s','delimiter','\n');%载入正样本列表  
sz1=size(ReadList1);  
label1=ones(sz1(1),1); %正样本标签1 

ReadList2  = textread('neg_list.txt','%s','delimiter','\n');%载入负样本列表  
sz2=size(ReadList2);  
label2=zeros(sz2(1),1);%负样本标签  

label=[label1',label2']';%标签汇总  
total_num=length(label);  
data=zeros(total_num,1764); 

%读取正样本并计算hog特征  
for i=1:sz1(1)  
   name= char(ReadList1(i,1));
   img=imread(strcat('Pos\',name));%这里每一个item不同  
   img=imresize(img,[128,128]);
   img=rgb2gray(img);  
   hog =Find_HOG_Vectors(img);  
   for ii=1:49
       x=hog{1,ii};
       data(i,((ii-1)*36+1):ii*36)=x;
   end
end  

%读取负样本并计算hog特征  
for j=1:sz2(1)  
   name= char(ReadList2(j,1));  
   img=imread(strcat('Neg\',name));  
   img=imresize(img,[128,128]);
   img=rgb2gray(img);  
   hog =Find_HOG_Vectors(img);  
    for jj=1:49
       y=hog{1,jj};
       data(sz1(1)+j,(36*(jj-1)+1):36*jj)=y;
   end
end  

svmStruct = fitcsvm(data,label);  
save svmStruct svmStruct   

end