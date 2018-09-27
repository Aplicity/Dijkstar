function [minp, path_n] = findminpath(Net, ni, nj) %To find the minimum path of two given nodes ni and nj.
%%%ni is the start node while nj is the target node. minp is the number of
%%%minimum pathlength while path_n preserves the order of nodes in this
%%%path.
l=length(Net);
used=zeros(1,l); %%%used nodes
clu=zeros(1,l); %%% prepared for use
clu(ni)=1;
i=ni;
jdg=0;
if ni==nj 
    mp=0;
else
    while jdg==0
        cur=max(used+1);
        for j=1:l
            if Net(nj,j)==1 & clu(j)==cur
                mp=cur; %%% step number of path
                used(j)=cur;
                jdg=1;
                break
            elseif clu(j)==cur
                newl=find(Net(j,:)==1 & clu==0); %%% the order number new layer nodes
                clu(newl)=cur+1;
                used(j)=cur;
            end
        end
        if length(find(clu==cur+1))==0 & jdg==0
            mp=inf;
            jdg=1;
        end
    end
end
minp=mp;

if mp~=inf
    path=zeros(1,mp+1);
    path(mp+1)=nj;
    cur=mp;
    while cur~=0
        pr=find(Net(path(cur+1),:)==1 & clu==cur);
        path(cur)=pr(1);
        cur=cur-1;
    end
else
    path=inf;
end
path_n=path;
                