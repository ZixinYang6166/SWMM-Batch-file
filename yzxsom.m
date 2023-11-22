
%��������������֯����ӳ���㷨�������㵰��ũ����Ʒ��һ������
%������ѡ��40�������㵰��ʳ����Ϊ����
%�������������\������\֬������ָ�����
%�����㵰��ũ����Ʒ����ģʽ:��֬����\��֬����\��֬����

%Self Organized Feature Mapping(SOFM)
%==========================================
clear

%�����������

Q=500;            %ѵ��������
N=10;             %��������ά��
lr=0.1;          %��ʼѧϰ��
M=6;             %Kohonen����Ԫ��
disp_freq=100;    %����״̬����l��
max_epoch =1000;  %���ѵ������

%��ʼ��Ȩ����Ϊ��������洢��Ԫ
W=rands(M,N);                %Ȩ����
X0=zeros(N,Q);               %����ģʽ����
A=zeros(M,1);                %Kohonen����Ԫ����Ӧ����

%������������
%X0=[72 139 190 98 106 142 264 129 816 395 331 155 349 338 143 167 389 121 118 461 143 138 156 328 44 180 378 112 127 143 109 124 99 262 163 118 230 95 252 108;
   %14.5 19.8 18.1 19.8 20.2 11.3 18.3 19.3 2.4 13.5 14.6 20.2 7.7 15.1 20.3 19.3 16.7 16.6 19.2 13 12.8 12.7 12.8 15.2 9.8 12.6 14.5 16.6 17.7 17.2 17.6 18.5 17.9 50.2 22.7 17.8 21.5 13.8 10.9 17.1;
   %1.6 3.9 13.4 2 5.23 10.7 20.4 3.5 90.4 37 30.8 7.9 35.3 31.5 6.2 9.4 35.4 4.8 2.8 44.8 8.9 9 11.1 28.2 0.1 13. 33.8 5.2 4.9 8.6 4.1 3.4 3 4.8 3.5 4.3 13. 2.3 16.8 2.7];
X3=xlsread('yzx_som.xls',['C2:L501']); 
X0=X3';
   
%�������������й�һ��
XMEAN0=mean(X0');XSTD0=std(X0');
XMEAN=ones(Q,1)*XMEAN0;XMEAN=XMEAN';
XSTD=ones(Q,1)*XSTD0;XSTD=XSTD';
X=(X0-XMEAN)./XSTD;
for q=1:Q
   X(:,q)=X(:,q)/sqrt(X(:,q)'*X(:,q));
end


%��Ȩ�����й�һ��
for m=1:M
   W(m,:)=W(m,:)/sqrt(W(m,:)*W(m,:)');
end

%ѧϰ����
disp('Tranining begins...')
for epoch=1:max_epoch
   for q=1:Q
      %��Kohonen����������Ӧ
      for m=1:M
         A(m)=(X(:,q)'-W(m,:))*(X(:,q)-W(m,:)');
      end
      min_d=A(1);j=1;
      for m=2:M
         if A(m)<min_d
            min_d=A(m);j=m;
         end
      end
      %����ѧϰ��lr��ʤ��garma��Ȩ����W
      lr=0.7*(1-((epoch-1)*Q+q-1)/(max_epoch*Q));
      garma=1.7*(1-((epoch-1)*	Q+q-1)/(max_epoch*Q));
      rowj=fix((j-1)/M)+1;
      colj=rem(j-1,M)+1;
      for m=1:M
         rowm=fix((m-1)/M)+1;
         colm=rem(m-1,M)+1;
         dist=sqrt((rowj-rowm)^2+(colj-colm)^2);
         %�޸�Ȩֵ����һ��Ȩ����
         if(dist<garma)
            W(m,:)=W(m,:)+lr*(X(:,q)'-W(m,:));
            W(m,:)=W(m,:)/sqrt(W(m,:)*W(m,:)');
         end
      end
   end
   
      %��ʾ��ǰȨ����
      if (rem(epoch,disp_freq)==0)
         fprintf('\nEpoch=%5.0f\n',epoch);
         
      end
   end
   
   

%���������
disp('');
disp('Vectors and their classification:');
for q=1:Q
  %��Kohonen����������Ӧ
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
%�����㵰��ũ����Ʒ����ͼ��
%plot3(X(1,:),X(2,:),X(3,:),'*k',W(:,1),W(:,2),W(:,3),'ok')
title('����/Ȩ����')
xlabel('����')
ylabel('������')
zlabel('֬��')

