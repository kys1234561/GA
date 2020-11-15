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
    scatter(x(i),y(i),'b');            %画出散点图
    text(x(i),y(i),num2str(i-1))
   hold on
end
a=sj;
d1=sj(1,:);
sj0=[sj;d1];
sj=sj0*pi/180;%将角度制转化为弧度制。
d=zeros(31);
for i=1:30
 for j=i+1:31
 temp=cos(sj(i,1)-sj(j,1))*cos(sj(i,2))*cos(sj(j,2))+sin(sj(i,2))*sin(sj(j,2));
 d(i,j)=6370*acos(temp);
 end
end
%距离矩阵 d
d=d+d';L=31;w=500;dai=100;
%通过改良圈算法选取优良父代 A,方法设计的不错
for k=1:w
 c=randperm(30);%随机排列1到30的数
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
rand('state',sum(clock));%命令rand('state',sum(clock))是每次产生随机数的时候，随机数生成器触发器的状态都会翻转一次。
%matlab生成的是伪随机数。
%遗传算法实现过程
A=J;
for k=1:dai %产生 0～1 间随机数列进行编码
 B=A;
 c=randperm(w);
%交配产生子代 B，(交换)，此处的设计认为是肯定发生交配，并且成功
 for i=1:2:w
 F=2+floor(29*rand(1));
 temp=B(c(i),F:31);
 B(c(i),F:31)=B(c(i+1),F:31);
 B(c(i+1),F:31)=temp;
 end 
%变异产生子代 C
by=find(rand(1,w)<0.1);%这个地方的变异的概率是0.9.^50，等于0.0052，即by为空的概率为0.52%。
if isempty(by)
 by=floor(w*rand(1))+1;
end
C=A(by,:);
L3=length(by);
for j=1:L3
 bw=2+floor(30*rand(1,3));
 bw=sort(bw);
 C(j,:)=C(j,[1:bw(1)-1,bw(2)+1:bw(3),bw(1):bw(2),bw(3)+1:31]);%变异只会在自己的身上变异。
end
 G=[A;B;C];
 TL=size(G,1);%算出G的行数
 %在父代和子代中选择优良品种作为新的父代
 [dd,IX]=sort(G,2);temp(1:TL)=0;% [dd,IX]=sort(G,2)，dd返回值，IX返回位置。以行来进行。
 for j=1:TL
 for i=1:30
 temp(j)=temp(j)+d(IX(j,i),IX(j,i+1));%求路径和
 e(i,j)=IX(j,i);
 end
 end
 [DZ,IZ]=sort(temp);%DZ是返回值，IZ是返回位置，默认从小到大排序，选择路径小的并且进行种群更新，但是种群的数量不变。DZ就是总距离
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
xlswrite('F:\深圳杯数学建模大赛\C题\第2小题\c1_1.xlsx',long);