# NHHeaderFloatPro
### ScrollView Section Header 悬停 （For iOS）
##### 1、本demo主要实现上拉悬停，即向上滚动TableView的时候section悬停在指定View（本例子当中为红色View）下方，而不是默认的顶部，此外指定的View也悬停而不随Header滚动上去
##### 2、如要实现下拉悬停则可参考scrollView的扩展，利用运行时实现

##### 类似与浙江新闻中的专题效果如图：
![image](https://github.com/iFindTA/screenshots/blob/master/zhuanti_0.PNG)
![image](https://github.com/iFindTA/screenshots/blob/master/zhuanti_1.png)
##### 本demo效果：

![image](https://github.com/iFindTA/screenshots/blob/master/zhuanti_section_floating.gif)

##### Usage：
主要方法是控制TableView的contentInset和contentOffset及委托方法ScrollViewDidScroll：方法

