clear
rand('state',sum(100*clock));%���������ȡ�����ָ��

L=3000;%L�ǽ����clock
T=10000000;%T��ʱ�䣬
seed=[0,1,1;1,0,1;1,1,0];
Net=SFNG(L,2,seed);%�������磬�����loop1D��һ��һά��״���磬����ֵ��Net�������

% %%%%Scale-Free Network%%%%%%%%%%%%%%
% seed=[0,1,1;1,0,1;1,1,0];
% Net=SFNG(L,2,seed);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ava=0.65;%������ѩ����Ӧ��ֵ����ͳ�Ƶ��ڸ���Ӧ��ֵ��ѩ�������Ĵ�С

fitness=rand(1,L);%fitness�洢�����н�����Ӧ�ȣ���Ӧ���ڿ�ʼʱ�������
Fithist=100; %��Ӧ�ȷֲ�ͳ�Ƶ�������
Pf=zeros(1,Fithist);%ÿ����������Ӧ��������ӵ�еĽ����
fmin=zeros(1,T);%�洢ÿһ������Ӧ����Сֵ

Pt=zeros(1,100);%ͳ�Ƹ�����С������¼����ֵ�ʱ�䳤��

Pt_a=zeros(1,1000000);%ͳ����Ӧ�ȵ���ĳ������ֵ���¼����ֵ�ʱ�䳤��

Pfmin=zeros(1,Fithist);%ÿ����������Ӧ����������С��Ӧ�ȳ��ֵĴ���

tr=0;%����ѩ����ĳһ������¼���ʱ���¼������
tL=zeros(1,L);%�洢��һ�����µĽ��
Lmin=L/2;%����뾶
td=zeros(1,L+1);%ÿһ�����µľ���ֲ�����һ��Ԫ���Ǿ���Ϊ0�Ĵ���������Ԫ����ĿҪ��1

tr_a=0;%���ڸ�����Ӧ��ֵ��ѩ��������ʱ���¼������

for t=1:T %�ݻ�ʱ��ѭ��
    [mf,mn]=min(fitness);%mf�����н������Ӧ�ȵ���Сֵ��mn��ӵ����С��Ӧ�ȵĽ��
    fmin(t)=mf;%�洢ÿһ������С��Ӧ��
    if max(tL)==2 %���if�����ã��ڵ�һ����tL��û�е���2��ֵ�����Ա����ų�����һ��
        rmn=find(tL==2);%�ҵ�tL�е���2��ֵ������Ӧ����С�Ľ�����ţ�
        [minp,path_n]=findminpath(Net,mn,rmn);%Ѱ�����·��
        td(minp+1)=td(minp+1)+1;%����·�����ȵ�ͳ����Ŀ��1
    end
    if tL(mn)==0 && tr~=0 %�·������µĽ�㲻����һ�����µ���һ����㣬���Ҵ�����Ϊ0������ͳ�Ƴ���ʱ��ĳ��ȷֲ�
        Pt(tr)=Pt(tr)+1;%��������ʱ��Ϊtr������Ĵ�����1
        tr=0;%����ʱ���¼����
    end
    
    if mf<Ava
        tr_a=tr_a+1;
    elseif tr_a~=0
        Pt_a(tr_a)=Pt_a(tr_a)+1;%��������ʱ��Ϊtr_a�ĵ��ڸ�����Ӧ��ֵ������Ĵ�����1
        tr_a=0;%���ڸ�����Ӧ��ֵ�ĳ���ʱ���¼����
        t
    end
    
    tr=tr+1;%�������ʱ���1
    tL=tL*0;%���tL
    r1=rand*1;
    fitness(mn)=r1;%������Ӧ����С�Ľ��
    tL(mn)=2;%��tL�а���Ӧ����С��������ϵ�Ԫ�ظ�ֵΪ2
    for ii=1:L %Ѱ������Ӧ����͵Ľ�����ڵĽ�㣬������֮
        if Net(mn,ii)==1
            fii=rand*1;
            fitness(ii)=fii;%��������Ӧ����С�Ľ�����ڵĽ��
            tL(ii)=1;%��tL�а���Ӧ����С�Ľ�����ڵĽ�������ϵ�Ԫ�ظ�ֵΪ1
        end
    end
    %%%%%%%%%%%ͳ��ÿһ����Ӧ�ȵķֲ�%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%�������ʱ��ķֲ�%%%%%%%%%%%%%%%%
figure
nc=length(Pt);%��ͳ�Ƶ�����������ʱ��
loglog(1:nc,Pt,'ok');
title('Distribution of persist time of extinction', 'Fontsize', fs)
xlabel('persist time of distinction', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%���ڸ�����Ӧ��ֵ���������ʱ��ķֲ�%%%%%%%%%%%%%%%%
figure
nc_a=length(Pt_a);%��ͳ�Ƶ�����������ʱ��
loglog(1:nc_a,Pt_a/T,'ok');
title(['Distribution of persist time of avalanche below ',num2str(Ava)], 'Fontsize', fs)
xlabel('persist time of distinction', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%�������ķֲ�%%%%%%%%%%%%%%%%
figure
nd=0:L;%��ͳ�Ƶ�����������ʱ��
loglog(nd,td,'ok');
title('Distribution of distance between two successive mutation', 'Fontsize', fs)
xlabel('Distance between two successive mutation', 'Fontsize', fs)
ylabel('Count number', 'Fontsize', fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%��Ӧ�ȵķֲ�%%%%%%%%%%%%%%%%
% Fithist=100; %��Ӧ�ȷֲ�ͳ�Ƶ�������
% Pf=zeros(1,Fithist);%ÿ����������Ӧ��������ӵ�еĽ����
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