
%本程序利用自组织特征映射算法将肉禽鱼蛋类农副产品进一步分类
%本程序选用40种肉禽鱼蛋类食物作为样本
%本程序根据能量\蛋白质\脂肪三项指标分类
%肉禽鱼蛋类农副产品分类模式:低脂肪组\中脂肪组\高脂肪组

%Self Organized Feature Mapping(SOFM)
%==========================================
clear

%输入网络参数

Q=500;            %训练样本数
N=10;             %输入向量维数
lr=0.1;          %初始学习率
M=6;             %Kohonen层神经元数
disp_freq=100;    %网络状态输出頻率
max_epoch =1000;  %最大训练次数

%初始化权矩阵并为变量分配存储单元
W=rands(M,N);                %权矩阵
X0=zeros(N,Q);               %输入模式矩阵
A=zeros(M,1);                %Kohonen层神经元的响应矩阵

%输入向量数据
%X0=[72 139 190 98 106 142 264 129 816 395 331 155 349 338 143 167 389 121 118 461 143 138 156 328 44 180 378 112 127 143 109 124 99 262 163 118 230 95 252 108;
   %14.5 19.8 18.1 19.8 20.2 11.3 18.3 19.3 2.4 13.5 14.6 20.2 7.7 15.1 20.3 19.3 16.7 16.6 19.2 13 12.8 12.7 12.8 15.2 9.8 12.6 14.5 16.6 17.7 17.2 17.6 18.5 17.9 50.2 22.7 17.8 21.5 13.8 10.9 17.1;
   %1.6 3.9 13.4 2 5.23 10.7 20.4 3.5 90.4 37 30.8 7.9 35.3 31.5 6.2 9.4 35.4 4.8 2.8 44.8 8.9 9 11.1 28.2 0.1 13. 33.8 5.2 4.9 8.6 4.1 3.4 3 4.8 3.5 4.3 13. 2.3 16.8 2.7];
X3=xlsread('yzx_som.xls',['C2:L501']); 
X0=X3';
   
%对输入向量进行归一化
XMEAN0=mean(X0');XSTD0=std(X0');
XMEAN=ones(Q,1)*XMEAN0;XMEAN=XMEAN';
XSTD=ones(Q,1)*XSTD0;XSTD=XSTD';
X=(X0-XMEAN)./XSTD;
for q=1:Q
   X(:,q)=X(:,q)/sqrt(X(:,q)'*X(:,q));
end


%对权量进行归一化
for m=1:M
   W(m,:)=W(m,:)/sqrt(W(m,:)*W(m,:)');
end

%学习过程
disp('Tranining begins...')
for epoch=1:max_epoch
   for q=1:Q
      %求Kohonen层最大输出响应
      for m=1:M
         A(m)=(X(:,q)'-W(m,:))*(X(:,q)-W(m,:)');
      end
      min_d=A(1);j=1;
      for m=2:M
         if A(m)<min_d
            min_d=A(m);j=m;
         end
      end
      %调整学习率lr和胜域garma及权矩阵W
      lr=0.7*(1-((epoch-1)*Q+q-1)/(max_epoch*Q));
      garma=1.7*(1-((epoch-1)*	Q+q-1)/(max_epoch*Q));
      rowj=fix((j-1)/M)+1;
      colj=rem(j-1,M)+1;
      for m=1:M
         rowm=fix((m-1)/M)+1;
         colm=rem(m-1,M)+1;
         dist=sqrt((rowj-rowm)^2+(colj-colm)^2);
         %修改权值并归一化权向量
         if(dist<garma)
            W(m,:)=W(m,:)+lr*(X(:,q)'-W(m,:));
            W(m,:)=W(m,:)/sqrt(W(m,:)*W(m,:)');
         end
      end
   end
   
      %显示当前权向量
      if (rem(epoch,disp_freq)==0)
         fprintf('\nEpoch=%5.0f\n',epoch);
         
      end
   end
   
   

%输出分类结果
disp('');
disp('Vectors and their classification:');
for q=1:Q
  %求Kohonen层最大输出响应
  for m=1:M
     A(m)=(X(:,q)'-W(m,:))*(X(:,q)-W(m,:)');
  end
  min_d=A(1);j=1;
  for m=2:M
     if A(m)<min_d
        min_d=A(m);j=m;
     end
  end

   fprintf('\n Vector: %3d is classified to Type: %2d',q,j);
 
fprintf('\n');
end 
%肉禽鱼蛋类农副产品分类图：
%plot3(X(1,:),X(2,:),X(3,:),'*k',W(:,1),W(:,2),W(:,3),'ok')
title('输入/权向量')
xlabel('能量')
ylabel('蛋白质')
zlabel('脂肪')

