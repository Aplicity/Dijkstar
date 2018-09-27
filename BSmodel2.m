clear
rand('state',sum(100*clock));%这个命令是取随机数指令

L=3000;%L是结点数clock
T=10000000;%T是时间，
seed=[0,1,1;1,0,1;1,1,0];
Net=SFNG(L,2,seed);%调用网络，这里的loop1D是一个一维环状网络，并赋值给Net这个矩阵

% %%%%Scale-Free Network%%%%%%%%%%%%%%
% seed=[0,1,1;1,0,1;1,1,0];
% Net=SFNG(L,2,seed);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ava=0.65;%给定的雪崩适应度值，即统计低于该适应度值的雪崩发生的大小

fitness=rand(1,L);%fitness存储了所有结点的适应度，适应度在开始时随机给定
Fithist=100; %适应度分布统计的区间数
Pf=zeros(1,Fithist);%每个给定的适应度区间中拥有的结点数
fmin=zeros(1,T);%存储每一步的适应度最小值

Pt=zeros(1,100);%统计给定大小的灭绝事件出现的时间长度

Pt_a=zeros(1,1000000);%统计适应度低于某个给定值的事件出现的时间长度

Pfmin=zeros(1,Fithist);%每个给定的适应度区间中最小适应度出现的次数

tr=0;%连续雪崩中某一次灭绝事件的时间记录计数器
tL=zeros(1,L);%存储上一步更新的结点
Lmin=L/2;%网络半径
td=zeros(1,L+1);%每一步更新的距离分布，第一个元素是距离为0的次数，所以元素数目要加1

tr_a=0;%低于给定适应度值的雪崩发生的时间记录计数器

for t=1:T %演化时间循环
    [mf,mn]=min(fitness);%mf是所有结点中适应度的最小值，mn是拥有最小适应度的结点
    fmin(t)=mf;%存储每一步的最小适应度
    if max(tL)==2 %这个if的作用：在第一步里tL中没有等于2的值，所以必须排除掉第一步
        rmn=find(tL==2);%找到tL中等于2的值（即适应度最小的结点的序号）
        [minp,path_n]=findminpath(Net,mn,rmn);%寻找最短路径
        td(minp+1)=td(minp+1)+1;%给定路径长度的统计数目加1
    end
    if tL(mn)==0 && tr~=0 %新发生更新的结点不是上一步更新的任一个结点，并且次数不为0，则需统计持续时间的长度分布
        Pt(tr)=Pt(tr)+1;%发生持续时间为tr的灭绝的次数加1
        tr=0;%持续时间记录清零
    end
    
    if mf<Ava
        tr_a=tr_a+1;
    elseif tr_a~=0
        Pt_a(tr_a)=Pt_a(tr_a)+1;%发生持续时间为tr_a的低于给定适应度值的灭绝的次数加1
        tr_a=0;%低于给定适应度值的持续时间记录清零
        t
    end
    
    tr=tr+1;%灭绝持续时间加1
    tL=tL*0;%清空tL
    r1=rand*1;
    fitness(mn)=r1;%更新适应度最小的结点
    tL(mn)=2;%在tL中把适应度最小结点的序号上的元素赋值为2
    for ii=1:L %寻找与适应度最低的结点相邻的结点，并更新之
        if Net(mn,ii)==1
            fii=rand*1;
            fitness(ii)=fii;%更新与适应度最小的结点相邻的结点
            tL(ii)=1;%在tL中把适应度最小的结点相邻的结点的序号上的元素赋值为1
        end
    end
    %%%%%%%%%%%统计每一步适应度的分布%%%%%%%%%%%%%%%%
    for iif=1:L
        for jjf=1/Fithist:1/Fithist:1
            if fitness(iif)<=jjf
                Pf(round(jjf*Fithist))=Pf(round(jjf*Fithist))+1;
                break
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

fs=16;
%%%%%%%%%%%灭绝持续时间的分布%%%%%%%%%%%%%%%%
figure
nc=length(Pt);%被统计的最大灭绝持续时间
loglog(1:nc,Pt,'ok');
title('Distribution of persist time of extinction', 'Fontsize', fs)
xlabel('persist time of distinction', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%低于给定适应度值的灭绝持续时间的分布%%%%%%%%%%%%%%%%
figure
nc_a=length(Pt_a);%被统计的最大灭绝持续时间
loglog(1:nc_a,Pt_a/T,'ok');
title(['Distribution of persist time of avalanche below ',num2str(Ava)], 'Fontsize', fs)
xlabel('persist time of distinction', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%灭绝距离的分布%%%%%%%%%%%%%%%%
figure
nd=0:L;%被统计的最大灭绝持续时间
loglog(nd,td,'ok');
title('Distribution of distance between two successive mutation', 'Fontsize', fs)
xlabel('Distance between two successive mutation', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%适应度的分布%%%%%%%%%%%%%%%%
% Fithist=100; %适应度分布统计的区间数
% Pf=zeros(1,Fithist);%每个给定的适应度区间中拥有的结点数
% for iif=1:L
%     for jjf=1/Fithist:1/Fithist:1
%         if fitness(iif)<=jjf
%             Pf(ceil(jjf*Fithist))=Pf(ceil(jjf*Fithist))+1;
%             break
%         end
%     end
% end
for ifmin=1:T
    for jfmin=1/Fithist:1/Fithist:1
        if fmin(ifmin)<=jfmin
            Pfmin(round(jfmin*Fithist))=Pfmin(round(jfmin*Fithist))+1;
            break
        end
    end
end

figure
plot(1/Fithist:1/Fithist:1,Pf/(L*T),'ok',1/Fithist:1/Fithist:1,Pfmin/(T),'*r');
title('Distribution of fitness', 'Fontsize', fs)
xlabel('fitness', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save NODE100_T10000000_SFNG