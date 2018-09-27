function [ loopNet ] = loop1D( n )

rand('state',sum(100*clock));

Net = zeros(n, n, 'single');

for ri=1:n
    if ri>1
        Net(ri,ri-1)=1; Net(ri-1,ri)=1;
    else 
        Net(ri,n)=1; Net(n,ri)=1;
    end
end
loopNet=Net;
