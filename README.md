# Dijkstar
Dijkstar求最短路
## 问题提出
	从某顶点出发，沿图的边到达另一个顶点所经过的路径中，各边上权值之和最小的一条路径————最短路径。

## Dijkstra算法
该算法于1959年提出，目前被认为是求非负权网络最短路问题的最好方法。算法的节本思想基于以下原理：
若序列{V(s),V(1),...,V(n-1),V(n)}是从V(s)到V(n)的最短路，则序列{V(s),V(1),...,V(n-1)}必为V(s)到V(n-1)的最短路。
 * 先把节点集合V分成两组：
	- S：已求出最短路径的顶点的集合
	- V-S = T：尚未确定最短路径的顶点集合
		将T中顶点按最短路径递增的次序加入到S中，依据：可以证明V0到T中顶点Vk的最短路径，或是从V0到Vk的直接路径的权值或是从V0经S中顶点到Vk的路径权值之和
* 求解算法
	- （1）节点初始化。初始时令S={V0},T={其余顶点}。若存在{V0,Vi}，T中顶点对应的距离值 为{V0,Vi}弧上的权值；若不存在<V0,Vi>，为Inf。
	- （2）从T中选取一个其距离值为最小的顶点W(贪心思想)，加入S(注意不是直接从S集合中选取，)，对T中顶点的距离值进行修改：若加进W作中间顶点，从V0到Vi的距离值比不加W的路径要短，则修改此距离值。
	- （3）重复上述步骤，直到S中包含所有顶点，即S=V为止（说明最外层是除起点外的遍历）

## 例题分析
假若有如下有向图，从V0出发，求各个点的最短路径
![image](https://github.com/Aplicity/Dijkstar/blob/master/question.png)

求解方法过程如下：
![image](https://github.com/Aplicity/Dijkstar/blob/master/answer.png)

## 代码
 * Matlab脚步：BSmodel2.m(主程序)、SFNG.m、loop1D.m、findminpath.m
 * Python: mian.py
 
