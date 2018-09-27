import numpy as np
import datetime
import random

def loop1D(n):
    Net = np.zeros((n, n));
    for ri in range(10):
        if ri > 0 :
            Net[ri,ri-1] = 1
            Net[ri-1,ri] = 1
        else:
            Net[ri,n-1] = 1
            Net[n-1,ri] = 1
    loopNet = Net
    return loopNet


def SFNG(Nodes,mlinks,seed):
    pos = len(seed)
    Net = np.zeros((Nodes, Nodes))
    Net[0:pos,0:pos] = seed
    sumlinks = sum(sum(Net))
    while pos < Nodes:
        pos = pos + 1
        linkage = 0
        while linkage != mlinks:
            rnode = int(random.random() * pos) + 1
            deg = sum(Net[:,rnode-1]) * 2
            rlink = random.random()
            if rlink < deg / sumlinks and Net[pos-1,rnode-1] != 1 and Net[rnode-1,pos-1] != 1 and rnode != pos:
                Net[pos-1,rnode-1] = 1
                Net[rnode-1,pos-1] = 1
                linkage = linkage + 1
                sumlinks = sumlinks + 2
    SFNet = Net
    return SFNet



def findminpath(Net,ni,nj):
    l = len(Net)
    used = np.zeros((1, l))
    clu = np.zeros((1, l))
    clu[0, ni - 1] = 1
    i = ni
    jdg = 0

    if ni == nj:
        mp = 0
    else:
        while jdg == 0:
            cur = max(max(used + 1))
            for j in range(l):
                if Net[nj - 1, j] == 1 and clu[0, j] == cur:
                    mp = cur
                    used[0, j] = cur
                    jdg = 1
                    break
                elif clu[0, j] == cur:
                    newl = []
                    for k in range(Net.shape[1]):
                        if Net[j, k] == 1 and clu[0, k] == 0:
                            newl.append(k)
                    clu[0, newl] = cur + 1
                    used[0,j] = cur
            ind = []
            for k in range(clu.shape[1]):
                if clu[0, k] == cur + 1:
                    ind.append(k)
            if len(ind) == 0 and jdg == 0:
                mp = np.inf
                jdg = 1

    minp = mp
    if mp != np.inf:
        path = np.zeros((1, int(mp) + 1))
        path[0, int(mp)] = nj
        cur = mp
        while cur != 0:
            pr = []
            for k in range(Net.shape[1]):
                if Net[int(path[0, int(cur)]), k] == 1 and clu[0, k] == cur:
                    pr.append(k)
            if pr ==[] :
                path[0,int(cur)] = 0
            else:
                path[0, int(cur)] = pr[0]
            cur = cur - 1
    else:
        path = np.inf
    path_n = path
    return minp , path_n



L=3000
T = 2
seed = np.array([[0,1,1],[1,0,1],[1,1,0]])
Net=loop1D(3000)
Ava = 0.65
fitness = np.random.rand(1,L)
Fithist = 100
Pf = np.zeros((1,Fithist))
fmin = np.zeros((1,T))
Pt = np.zeros((1,100))
Pt_a = np.zeros((1,1000000))
Pfmin = np.zeros((1,Fithist))
tr = 0
tL = np.zeros((1,L))
Lmin = L/2
td = np.zeros((1,L+1))
tr_a = 0

for t in range(T):
    mf = min(fitness[0])
    mn = np.argsort(fitness[0])[0]
    fmin[0, t] = mf
    if max(tL[0]) == 2:
        rmn = []
        for k in range(tL.shape[1]):
            if tL[0, k] == 2:
                rmn.append(k)
                break

        minp, path_n = findminpath(Net, mn, rmn[0])
        td[0, int(minp)] = td[0, int(minp)] + 1
    if tL[0, mn] == 0 and tr != 0:
        Pt[0, tr] = Pt[0, tr] + 1
        tr = 0
    if mf < Ava:
        tr_a = tr_a + 1
    elif tr_a != 0:
        Pt_a[0, tr_a] = Pt_a[0, tr_a] + 1
        tr_a = 0
    tr = tr + 1
    tL = tL * 0
    r1 = random.random() * 1
    fitness[0, mn] = r1
    tL[0, mn] = 2
    for ii in range(L):
        if Net[mn, ii] == 1:
            fii = random.random()
            fitness[0, ii] = fii
            tL[0, ii] = 1
    for iif in range(L):
        for i in range(1, Fithist + 1):
            jjf = i / Fithist
            if fitness[0, iif] <= jjf:
                Pf[0, round(jjf * Fithist) - 1] = Pf[0, round(jjf * Fithist) - 1] + 1
                break
fs = 16

import matplotlib.pyplot as plt
nc=len(Pt[0])
plt.figure(1)
plt.loglog(range(1,nc+1),Pt[0],'o')
plt.title('Distribution of persist time of extinction',size = fs)
plt.xlabel('persist time of distinction',size = fs)
plt.ylabel('Count number',size = fs)

plt.figure(2)
nc_a=len(Pt_a[0])
plt.loglog(range(1,nc_a+1),(Pt_a/T)[0],'o');
plt.title('Distribution of persist time of avalanche below 0.65',size =  fs)
plt.xlabel('persist time of distinction', size = fs)
plt.ylabel('Count number', size = fs)


plt.figure(3)
nd= range(L+1)
plt.loglog(nd,td[0],'o')
plt.title('Distribution of distance between two successive mutation',size = fs)
plt.xlabel('Distance between two successive mutation',size = fs)
plt.ylabel('Count number', size = fs)

for ifmin in range(T):
    for j in range(1,Fithist+1):
        jfmin = j/Fithist
        if fmin[0,ifmin] <= jfmin:
            Pfmin[0,round(jfmin*Fithist)] = Pfmin[0,round(jfmin*Fithist)]+1
            break

plt.figure(4)
plt.plot(np.linspace(1/Fithist,1,Fithist),Pf[0]/(L*T))
plt.plot(np.linspace(1/Fithist,1,Fithist),Pfmin[0]/(T))
plt.title('Distribution of fitness', size = fs)
plt.xlabel('fitness', size = fs)
plt.ylabel('Count number',size = fs)
plt.show()

