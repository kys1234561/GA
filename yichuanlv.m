clc,clear
read=xlsread('C1_01.xlsx');
x=read(:,1);
y=read(:,2);
x=x(:);
y=y(:);
sj=[x y];
sj1=sj;
N=30;
e=zeros(31,31);
for i = 1 : N
    scatter(x(i),y(i),'b');            %����ɢ��ͼ
    text(x(i),y(i),num2str(i-1))
   hold on
end
a=sj;
d1=sj(1,:);
sj0=[sj;d1];
sj=sj0*pi/180;%���Ƕ���ת��Ϊ�����ơ�
d=zeros(31);
for i=1:30
 for j=i+1:31
 temp=cos(sj(i,1)-sj(j,1))*cos(sj(i,2))*cos(sj(j,2))+sin(sj(i,2))*sin(sj(j,2));
 d(i,j)=6370*acos(temp);
 end
end
%������� d
d=d+d';L=31;w=500;dai=100;
%ͨ������Ȧ�㷨ѡȡ�������� A,������ƵĲ���
for k=1:w
 c=randperm(30);%�������1��30����
 c1=[c,31];
 for t=1:1:31
     flag=0;
 for m=1:L-2
 for n=m+2:L-1
 if  d(c1(m),c1(n))+d(c1(m+1),c1(n+1))<d(c1(m),c1(m+1))+d(c1(n),c1(n+1))
 flag=1;
 c1(m+1:n)=c1(n:-1:m+1);
 end
 end
 end
 if flag==0
     J(k,c1)=1:31;
     break;
 end
 end
end
J=J/31;
J(:,1)=0;J(:,31)=1;
rand('state',sum(clock));%����rand('state',sum(clock))��ÿ�β����������ʱ���������������������״̬���ᷭתһ�Ρ�
%matlab���ɵ���α�������
%�Ŵ��㷨ʵ�ֹ���
A=J;
for k=1:dai %���� 0��1 ��������н��б���
 B=A;
 c=randperm(w);
%��������Ӵ� B��(����)���˴��������Ϊ�ǿ϶��������䣬���ҳɹ�
 for i=1:2:w
 F=2+floor(29*rand(1));
 temp=B(c(i),F:31);
 B(c(i),F:31)=B(c(i+1),F:31);
 B(c(i+1),F:31)=temp;
 end 
%��������Ӵ� C
by=find(rand(1,w)<0.1);%����ط��ı���ĸ�����0.9.^50������0.0052����byΪ�յĸ���Ϊ0.52%��
if isempty(by)
 by=floor(w*rand(1))+1;
end
C=A(by,:);
L3=length(by);
for j=1:L3
 bw=2+floor(30*rand(1,3));
 bw=sort(bw);
 C(j,:)=C(j,[1:bw(1)-1,bw(2)+1:bw(3),bw(1):bw(2),bw(3)+1:31]);%����ֻ�����Լ������ϱ��졣
end
 G=[A;B;C];
 TL=size(G,1);%���G������
 %�ڸ������Ӵ���ѡ������Ʒ����Ϊ�µĸ���
 [dd,IX]=sort(G,2);temp(1:TL)=0;% [dd,IX]=sort(G,2)��dd����ֵ��IX����λ�á����������С�
 for j=1:TL
 for i=1:30
 temp(j)=temp(j)+d(IX(j,i),IX(j,i+1));%��·����
 e(i,j)=IX(j,i);
 end
 end
 [DZ,IZ]=sort(temp);%DZ�Ƿ���ֵ��IZ�Ƿ���λ�ã�Ĭ�ϴ�С��������ѡ��·��С�Ĳ��ҽ�����Ⱥ���£�������Ⱥ���������䡣DZ�����ܾ���
 A=G(IZ(1:w),:);
end
path=IX(IZ(1),:);
b=path-1;
b=b';
b(31)=0;
long=DZ(1);
short=IX-1;
short(:,31)=0;
xx=sj0(path,1);yy=sj0(path,2);
plot(xx,yy,'-o') 
xlswrite('F:\���ڱ���ѧ��ģ����\C��\��2С��\c1_1.xlsx',long);