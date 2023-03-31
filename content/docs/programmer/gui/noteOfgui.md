---
title: 图形化界面 （Python Gui）
date: 2017-07-01 21:20
modified: 2018-05-15 11:40
category: [note, Gui, learning]
tags: [python, pyqt, Gui]
slug: notesPython
---
author:Ian

# Python GUI 💽

## pynput
在 pynput 模块中，Win键被称为“特殊键”（Special keys），需要使用特殊的名称来表示。

以下是可以使用的特殊键名称列表：
- https://pynput.readthedocs.io/en/latest/keyboard.html?highlight=%3Ccmd%3E#controlling-the-keyboard

因此，如果你想要在热键设置中使用 Win键+空格 这个热键，可以将它们分别替换为 cmd 和 space，如下所示：
```py
from pynput import keyboard

def on_activate():
    print('Hotkey activated')

def on_exit():
    print('Hotkey exited')
    return False

with keyboard.GlobalHotKeys({'<cmd>+<space>': on_activate}) as h:
    h.join(on_exit)```
在这个例子中，我们使用 <cmd>+<space> 来表示 Win键+空格 热键，因为在Mac中，Command键（cmd）可以起到类似于Win键的作用。
## PyQt
![qt](https://tse4-mm.cn.bing.net/th/id/OIP.J4_Nqrcc0x7slHHUFwKLSQHaI6?pid=ImgDet&rs=1 "tmp")

官方说明文档：<http://pyqt.sourceforge.net/Docs/PyQt4/index.html>
照例，先贴网址： <http://www.qaulau.com/books/PyQt4_Tutorial/index.html>

## 画界面
    #PyQt4使用designer.exe
    import os 
    for root, dirs, files in os.walk('.'): 
        for file in files: 
            if file.endswith('.ui'): 
                os.system('pyuic4 -o ui_%s.py %s' % (file.rsplit('.', 1)[0], file))
            elif file.endswith('.qrc'): 
                os.system('pyrcc4 -o %s_rc.py %s' % (file.rsplit('.', 1)[0], file))
    # 注：在Win中调用pyrcc4 可能无法识别该命令，即使添加到环境变量也不行，而是
    #pyrcc.exe才能调用简直……
#### 窗口设置
    resize(8, 8)
    setWindowTitle(u'标题')
#### 获取图标
    def getIcon(filename):
    """ 获取图标 """
        fileInfo = Qt.QFileInfo(filename) 
        fileIcon = Qt.QFileIconProvider() 
        icon = QtGui.QIcon(fileIcon.icon(fileInfo)) 
        return icon  
    使用时：
    self.setWindowIcon(getIcon('../hi/app.ico'))

---

##### Dock
    widgetTestM, dockTestM = self.createDock(AllMarketMonitor, vtText.“dock标题”, QtCore.Qt.RightDockWidgetArea)
    # 方向有： `RightDockWidgetArea`,`BottomDockWidgetArea`,`LeftDockWidgetArea`
    # 创建dock窗口
    # 可利用
    self.tabifyDockWidget(dockMarketM, dockAllDataM)
    来合并同一个方向上的dock
    
    # 此下还没看… 
    dockTradeM.raise_()
    dockPositionM.raise_()
    
    # 连接组件之间的信号
    widgetPositionM.itemDoubleClicked.connect(widgetTradingW.closePosition)
        
    # 保存默认设置
    self.saveWindowSettings('default')

其实现函数为：
"""创建停靠组件"""

    def createDock(self, widgetClass, widgetName, widgetArea):
        widget = widgetClass(self.mainEngine, self.eventEngine) 
        dock = QtGui.QDockWidget(widgetName)
        dock.setWidget(widget)
        dock.setObjectName(widgetName)
        dock.setFeatures(dock.DockWidgetFloatable|dock.DockWidgetMovable)
        self.addDockWidget(widgetArea, dock)
        return widget, dock
> 再本质一点的东西为：

    widget1 = Ha(self)
    dock = QtGui.QDockWidget('haha')
    dock.setObjectName('ha1')
    dock.setWidget(widget1)
    dock.setFeatures(dock.DockWidgetFloatable | dock.DockWidgetMovable)
    self.addDockWidget(QtCore.Qt.BottomDockWidgetArea, dock)

#### 动作
    exit = QtGui.QAction(QtGui.QIcon('hello.ico'), 'exit', self)
    exit.setShortcut('Ctrl+Q')
    exit.setStatusTip('Exit application')
    # 图标、文字、快捷键、提示信息
    
    menubar = self.menuBar()
    file = menubar.addMenu('&File')
    file.addAction(exit)
    # 创建目录和工具栏，将动作添加进去。工具栏同理

### 定位布局
#### 绝对定位
    label1 = QtGui.QLabel(u'绝对定位', self)
    label1.move(15, 60)
    # 创建、移动到显示位置

#### 框布局 及 布局元素平均分布
    okButton = QtGui.QPushButton("OK")
    cancelButton = QtGui.QPushButton("Cancel")
    # 创建按钮

    hbox = QtGui.QHBoxLayout()
    hbox.addStretch(1)
    hbox.addWidget(okButton)        # 增加组件
    hbox.addWidget(cancelButton)
    # 创建水平栏
    hbox.addStretch()   # 平均分布
    
    vbox = QtGui.QVBoxLayout()
    vbox.addStretch(1)
    # 创建竖列

    vbox.addLayout(hbox)
    # 将水平栏插入竖列
    self.setLayout(vbox)     
    # 显示最终竖列
注意一下add时选择对类型就好了。

### QTableWidget
<p><textarea cols="50" rows="15" name="code" class="python">#!/usr/bin/env python
#coding=utf-8
from PyQt4.QtGui  import *
from PyQt4.QtCore import *  
class MyDialog(QDialog):
    def __init__(self, parent=None):
        super(MyDialog, self).__init__(parent)
        self.MyTable = QTableWidget(4,3)
        self.MyTable.setHorizontalHeaderLabels(['姓名','身高','体重'])
        
        newItem = QTableWidgetItem(&quot;松鼠&quot;)
        self.MyTable.setItem(0, 0, newItem)
        
        newItem = QTableWidgetItem(&quot;10cm&quot;)
        self.MyTable.setItem(0, 1, newItem)
        
        newItem = QTableWidgetItem(&quot;60g&quot;)
        self.MyTable.setItem(0, 2, newItem) 
      
        layout = QHBoxLayout()
        layout.addWidget(self.MyTable)
        self.setLayout(layout)    
        
        
if __name__ == '__main__':
    import sys
    app = QApplication(sys.argv)
    myWindow = MyDialog()
    myWindow.show()
    sys.exit(app.exec_())       </textarea>
 </p>
<p>&nbsp;</p>
其中：
<p>self.MyTable = QTableWidget(4,3)&nbsp; 构造了一个QTableWidget的对象，并且设置为4行，3列</p><p>self.MyTable.setHorizontalHeaderLabels(['姓名','身高','体重']) 则设置表格的表头</p><p>newItem = QTableWidgetItem(&quot;松鼠&quot;)&nbsp;&nbsp; 则是生成了一个QTableWidgetItem的对象，并让其名为&ldquo;松鼠&rdquo;</p><p>self.MyTable.setItem(0, 0, newItem)&nbsp;&nbsp;&nbsp; 将刚才生成的Item加载到第0行、0列处
<p>&nbsp;</p>
<p>这样一个简单的QTableWidget就构造完成了。</p>
<p><img src="http://hi.csdn.net/attachment/201103/1/0_1298961912c0mN.gif" alt="" />
</p>

感谢[来源](view-source:blog.csdn.net/vah101/article/details/6215066)


### 以上。  之后的设置字体，底色，之类用的的时候再说。
其中： 
##### 合并单元格效果的实现：
    self.MyTable.setSpan(0, 0, 3, 1) 
    # 其参数为： 要改变单元格的 1行数  2列数     要合并的 3行数  4列数

##### 表格表头的显示与隐藏
    self.MyTable.verticalHeader().setVisible(False)
    self.MyTable.horizontalHeader().setVisible(False)
    # 默认显示 且标号为： 1，2，3…
#### 空位填补
    .addStretch()
    # 不过比较鸡肋，还是下面的调整窗口显示比例比较好玩
##### 调整各部分显示比例
    QVBoxLayout*  layout = new QVBoxLayout;
    QPushButton*      btn = new QPushButton;
    QTableWidget*     tableWidget = new QTableWidget;   
    QHBoxLayout*     h_layout = new QHBoxLayout;
    layout.addWidget(btn);
    layout.addWidget(tableWidget);
    layout.addLayout(h_layout)
    layout->setStretchFactor(btn, 1);
    layout->setStretchFactor(tableWidget, 2);
    layout->setStretchFactor(h_layout, 2);
上面是C++  所以下面的是俺的Python：
    hbox1[i].addWidget(self.buttonBox[i])
        hbox1[i].addWidget(self.paramMonitor[i])  
        hbox1[i].addWidget(self.varMonitor[i])
        # 设置显示比例
        hbox1[i].setStretchFactor(self.buttonBox[i], 3)
        hbox1[i].setStretchFactor(self.paramMonitor[i], 3)
        hbox1[i].setStretchFactor(self.varMonitor[i], 4)

### 列表内添加按钮
<p>1、定义添加按钮的方法</p>
<div class="cnblogs_code">
<pre><span style="color: #008080"> 1</span> <span style="color: #008000">#</span><span style="color: #008000"> 列表内添加按钮</span>
<span style="color: #008080"> 2</span>     <span style="color: #0000ff">def</span><span style="color: #000000"> buttonForRow(self,id):
</span><span style="color: #008080"> 3</span>         widget=<span style="color: #000000">QWidget()
</span><span style="color: #008080"> 4</span>         <span style="color: #008000">#</span><span style="color: #008000"> 修改</span>
<span style="color: #008080"> 5</span>         updateBtn = QPushButton(<span style="color: #800000">'</span><span style="color: #800000">修改</span><span style="color: #800000">'</span><span style="color: #000000">)
</span><span style="color: #008080"> 6</span>         updateBtn.setStyleSheet(<span style="color: #800000">'''</span><span style="color: #800000"> text-align : center;
</span><span style="color: #008080"> 7</span> <span style="color: #800000">                                          background-color : NavajoWhite;
</span><span style="color: #008080"> 8</span> <span style="color: #800000">                                          height : 30px;
</span><span style="color: #008080"> 9</span> <span style="color: #800000">                                          border-style: outset;
</span><span style="color: #008080">10</span> <span style="color: #800000">                                          font : 13px  </span><span style="color: #800000">'''</span><span style="color: #000000">)
</span><span style="color: #008080">11</span> 
<span style="color: #008080">12</span>         updateBtn.clicked.connect(<span style="color: #0000ff">lambda</span><span style="color: #000000">:self.updateTable(id))
</span><span style="color: #008080">13</span> 
<span style="color: #008080">14</span>         <span style="color: #008000">#</span><span style="color: #008000"> 查看</span>
<span style="color: #008080">15</span>         viewBtn = QPushButton(<span style="color: #800000">'</span><span style="color: #800000">查看</span><span style="color: #800000">'</span><span style="color: #000000">)
</span><span style="color: #008080">16</span>         viewBtn.setStyleSheet(<span style="color: #800000">'''</span><span style="color: #800000"> text-align : center;
</span><span style="color: #008080">17</span> <span style="color: #800000">                                  background-color : DarkSeaGreen;
</span><span style="color: #008080">18</span> <span style="color: #800000">                                  height : 30px;
</span><span style="color: #008080">19</span> <span style="color: #800000">                                  border-style: outset;
</span><span style="color: #008080">20</span> <span style="color: #800000">                                  font : 13px; </span><span style="color: #800000">'''</span><span style="color: #000000">)
</span><span style="color: #008080">21</span> 
<span style="color: #008080">22</span>         viewBtn.clicked.connect(<span style="color: #0000ff">lambda</span><span style="color: #000000">: self.viewTable(id))
</span><span style="color: #008080">23</span> 
<span style="color: #008080">24</span>         <span style="color: #008000">#</span><span style="color: #008000"> 删除</span>
<span style="color: #008080">25</span>         deleteBtn = QPushButton(<span style="color: #800000">'</span><span style="color: #800000">删除</span><span style="color: #800000">'</span><span style="color: #000000">)
</span><span style="color: #008080">26</span>         deleteBtn.setStyleSheet(<span style="color: #800000">'''</span><span style="color: #800000"> text-align : center;
</span><span style="color: #008080">27</span> <span style="color: #800000">                                    background-color : LightCoral;
</span><span style="color: #008080">28</span> <span style="color: #800000">                                    height : 30px;
</span><span style="color: #008080">29</span> <span style="color: #800000">                                    border-style: outset;
</span><span style="color: #008080">30</span> <span style="color: #800000">                                    font : 13px; </span><span style="color: #800000">'''</span><span style="color: #000000">)
</span><span style="color: #008080">31</span> 
<span style="color: #008080">32</span> 
<span style="color: #008080">33</span>         hLayout =<span style="color: #000000"> QHBoxLayout()
</span><span style="color: #008080">34</span> <span style="color: #000000">        hLayout.addWidget(updateBtn)
</span><span style="color: #008080">35</span> <span style="color: #000000">        hLayout.addWidget(viewBtn)
</span><span style="color: #008080">36</span> <span style="color: #000000">        hLayout.addWidget(deleteBtn)
</span><span style="color: #008080">37</span>         hLayout.setContentsMargins(5,2,5,2<span style="color: #000000">)
</span><span style="color: #008080">38</span> <span style="color: #000000">        widget.setLayout(hLayout)
</span><span style="color: #008080">39</span>         <span style="color: #0000ff">return</span> widget</pre>
</div>
<p>2、在向tableWidget里添加数据时插入即可</p>
<div class="cnblogs_code">
<pre><span style="color: #008080">1</span> <span style="color: #0000ff">for</span> row_number, row_data <span style="color: #0000ff">in</span><span style="color: #000000"> enumerate(rsdata):
</span><span style="color: #008080">2</span> <span style="color: #000000">    self.ui.tableWidget.insertRow(row_number)
</span><span style="color: #008080">3</span>     <span style="color: #0000ff">for</span> i <span style="color: #0000ff">in</span> range(len(row_data)+1<span style="color: #000000">):
</span><span style="color: #008080">4</span>         <span style="color: #0000ff">if</span> i&lt;<span style="color: #000000">len(row_data):
</span><span style="color: #008080">5</span> <span style="color: #000000">            self.ui.tableWidget.setItem(row_number, i, QtWidgets.QTableWidgetItem(str(row_data[i])))
</span><span style="color: #008080">6</span>         <span style="color: #008000">#</span><span style="color: #008000"> 添加按钮</span>
<span style="color: #008080">7</span>         <span style="color: #0000ff">if</span> i==<span style="color: #000000">len(row_data):
</span><span style="color: #008080">8</span>             <span style="color: #008000">#</span><span style="color: #008000"> 传入当前id</span>
<span style="color: #008080">9</span>             self.ui.tableWidget.setCellWidget(row_number, i,self.buttonForRow(str(row_data[0])))</pre>
</div>
<p>效果图</p>
<p><img src="http://images2017.cnblogs.com/blog/896442/201709/896442-20170907222902741-300228307.png" alt=""></p>

就像以上显示的那样[来源](https://www.cnblogs.com/yuanlipu/p/7492260.html)

#### 值得注意的是，再排布的时候必须只有一个表格对其进行放置（也就是说指挥它去哪儿的只能有一个人），之前我为了测试，两个hbox 对其进行排版，简直……

        labelSymbol = QtGui.QLabel(self.CtaEngine.strategyTickDict[self.name])
        buttonInit[i] = QtGui.QPushButton(u'初始化')
        buttonStart[i] = QtGui.QPushButton(u'启动')
        buttonStop[i] = QtGui.QPushButton(u'停止')
        buttonUpdate[i] = QtGui.QPushButton(u'更新参数')
        buttonSave[i] = QtGui.QPushButton(u'保存参数')

        buttonInit[i].clicked.connect(partial(self.init, i))
        buttonStart[i].clicked.connect(partial(self.start, i))
        buttonStop[i].clicked.connect(partial(self.stop, i))
        buttonUpdate[i].clicked.connect(partial(self.updateParams,i))
        buttonSave[i].clicked.connect(partial(self.saveParams, i))
    
    hbox1[i] = QtGui.QHBoxLayout()
        ##参数设置显示
        hbox2[i] = QtGui.QHBoxLayout()
            #hbox1[i].addWidget(labelSymbol)
            #hbox1[i].addWidget(buttonInit[i])
            #hbox1[i].addWidget(buttonStart[i])
            #hbox1[i].addWidget(buttonStop[i])
            #hbox1[i].addWidget(buttonUpdate[i])
            #hbox1[i].addWidget(buttonSave[i])

        self.buttonBox[i].setCellWidget(0, 0, buttonInit[i])
        self.buttonBox[i].setCellWidget(0, 1, buttonStart[i])
        self.buttonBox[i].setCellWidget(0, 2, buttonStop[i])


---

---

---

#### 组件之间连接信号
    # classA(QtGui.QTableWidget):
    #   pass
    classA.itemDoubleClicked.connect(classB.actionFunction)
    # 这样单纯调用还是可以的，但是数据传输… 就得继续研究一下了。
##### 关闭事件退出提示
    def closeEvent(self, event):
        reply = QtGui.QMessageBox.question(self, 'Message',"Are you sure to quit?",

            QtGui.QMessageBox.Yes, QtGui.QMessageBox.No)
    if reply == QtGui.QMessageBox.Yes:
        event.accept()
    else:
        event.ignore()
函数放置位置就是主窗口类下就好。

### QTableWidget 清除数据
    def updateData(self, data): #（缩进没问题吧…🙏）
            """将数据更新到表格中"""
        
        if self.name == u'RiskAlarmWidget':
            pass

        if self.updateBeginAction:
            data = self.updateBeginAction(data)
            if not data:
               return

        if self.updateAction:
            self.updateAction(data)
        else:
            if isinstance(data, unicode) and self.dataKey:
                # 删除模式
                key = data
                if key in self.dataDict:
                    d = self.dataDict[key]
                    row = d[self.headerList[0]].row()
                    self.removeRow(row)
                    del self.dataDict[key]
            else:
                # 如果设置了dataKey，则采用存量更新模式
                if self.InsertMode:
                    # 如果允许了排序功能，则插入数据前必须关闭，否则插入新的数据会变乱
                    if self._sorting:
                        self.setSortingEnabled(False)

                    newRow = 0 if self.InsertTopRow else self.rowCount()
                    self.insertRow(newRow)

                    for n, header in enumerate(self.headerList):

                        content = self.getContents(data, header)
                        cellType = self.headerDict[header]['cellType']
                        cell = cellType(content)
                
                        if self.font:
                            cell.setFont(self.font)

                        if self._saveData:            
                            cell.data = data                

                        self.setItem(newRow, n, cell)  
        
                    # 重新打开排序
                    if self._sorting:
                        self.setSortingEnabled(True)
          
                else:            
                    key = data.__getattribute__(self.dataKey)
                    if key in self.dataDict:
                        # 已存在数据字典中，则更新相关单元格
                        d = self.dataDict[key]
                        for header in self.headerList:

                            content = self.getContents(data, header)
                            cell = d[header]
                            cell.setContent(content)

                            if self._saveData:            
                # 如果设置了保存数据对象，则进行对象保存
                                cell.data = data                    
                    else:
                        # 如果允许了排序功能，则插入数据前必须关闭，
            #否则插入新的数据会变乱
                        if self._sorting:
                            self.setSortingEnabled(False)
                        # 不存在数据字典中，插入新行，创建此行单元格
                        newRow = 0 if self.InsertTopRow else self.rowCount()
                        self.insertRow(newRow)
 
                        d = {}
                        for n, header in enumerate(self.headerList):
                        
                            content = self.getContents(data, header)
                            cellType = self.headerDict[header]['cellType']
                            cell = cellType(content)
                    
                            if self.font:
                                cell.setFont(self.font)  
                # 如果设置了特殊字体，则进行单元格设置
                    
                            if self._saveData:            
                # 如果设置了保存数据对象，则进行对象保存
                                cell.data = data
                        
                            self.setItem(newRow, n, cell)
                            d[header] = cell
                        self.dataDict[key] = d
        
                        # 重新打开排序
                        if self._sorting:
                            self.setSortingEnabled(True)

        if self.updateAfterAction:
            self.updateAfterAction(data)            

插入后数据需要清理只需`.clearContentsText()`，这样是清理数据但保留表格，方便更新内容。`.clear()`则清理数据以及表格方便<font color=75362109>重新</font>填入新的内容

---

#### 调用Windows程序
    import win32api
        path = 'D:/.../dockerTrader/gateway/ctpGateway/CTP_connect.json'
        win32api.ShellExecute(0, 'open', 'notepad.exe', path, '', 1)
    # 使用记事本打开此文件

---

#### Json
    with open('D:/.../dockerTrader/gateway/ctpGateway/CTP_connect.json', 'r') as f:
    setting = json.load(f)
    self.userID = str(setting['userID'])
    self.password = str(setting['password'])

---

---

### 信号槽（传输额外参数）
一般来说，比如一个按钮吧。 在链接点击信号与槽时`buttonInit[i].clicked.connect(partial(self.init, i))`就完事了。然而，当循环创建按钮，对应同样的槽函数，只是需要执行的变量有区别时，就需要传输额外的参数。
这时，方法有二：

环境：

python2.7.8

pyqt 4.11.1
### 一： 使用lambda表达式
<pre class="prettyprint"><code class="language-python hljs "><span class="hljs-keyword">from</span> PyQt4.QtCore <span class="hljs-keyword">import</span> *  
<span class="hljs-keyword">from</span> PyQt4.QtGui <span class="hljs-keyword">import</span> *  

<span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">MyForm</span><span class="hljs-params">(QMainWindow)</span>:</span>  
    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">__init__</span><span class="hljs-params">(self, parent=None)</span>:</span>  
        super(MyForm, self).__init__(parent)  
        button1 = QPushButton(<span class="hljs-string">'Button 1'</span>)  
        button2 = QPushButton(<span class="hljs-string">'Button 1'</span>)  
        button1.clicked.connect(<span class="hljs-keyword">lambda</span>: self.on_button(<span class="hljs-number">1</span>))  
        button2.clicked.connect(<span class="hljs-keyword">lambda</span>: self.on_button(<span class="hljs-number">2</span>))  

        layout = QHBoxLayout()  
        layout.addWidget(button1)  
        layout.addWidget(button2)  

        main_frame = QWidget()  
        main_frame.setLayout(layout)  

        self.setCentralWidget(main_frame)  

    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">on_button</span><span class="hljs-params">(self, n)</span>:</span>  
        print(<span class="hljs-string">'Button {0} clicked'</span>.format(n))  

<span class="hljs-keyword">if</span> __name__ == <span class="hljs-string">"__main__"</span>:  
    <span class="hljs-keyword">import</span> sys  
    app = QApplication(sys.argv)  
    form = MyForm()  
    form.show()  
    app.exec_()  </code></pre>

<p>解释一下，on_button是怎样处理从两个按钮传来的信号。我们使用lambda传递按钮数字给槽，也可以传递任何其他东西—甚至是按钮组件本身（假如，槽打算把传递信号的按钮修改为不可用）</p>

### 二： 使用functools里的partial函数
<pre class="prettyprint"><code class="language-python hljs ">button1.clicked.connect(partial(self.on_button, <span class="hljs-number">1</span>))  
button2.clicked.connect(partial(self.on_button, <span class="hljs-number">2</span>))  </code></pre>

<p>《Rapid GUI Program with Python and QT》 P143例子。</p>

<pre class="prettyprint"><code class="language-python hljs "><span class="hljs-keyword">from</span> PyQt4.QtCore <span class="hljs-keyword">import</span> *  
<span class="hljs-keyword">from</span> PyQt4.QtGui <span class="hljs-keyword">import</span> *  
<span class="hljs-keyword">from</span> functools <span class="hljs-keyword">import</span> partial  
<span class="hljs-keyword">import</span> sys  

<span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">Bu1</span><span class="hljs-params">(QWidget)</span>:</span>  

    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">__init__</span><span class="hljs-params">(self, parent=None)</span>:</span>  
        super(Bu1, self).__init__(parent)  
        <span class="hljs-comment">#水平盒式布局  </span>
        layout = QHBoxLayout()  
        <span class="hljs-comment">#显示  </span>
        self.lbl = QLabel(<span class="hljs-string">'no button is pressed'</span>)  
        <span class="hljs-comment">#循环5个按钮  </span>
        <span class="hljs-keyword">for</span> i <span class="hljs-keyword">in</span> range(<span class="hljs-number">5</span>):  
            but = QPushButton(str(i))  
            layout.addWidget(but)  
            <span class="hljs-comment">#信号和槽连接  </span>
            but.clicked.connect(self.cliked)  

        <span class="hljs-comment">#使用封装，lambda  </span>
        but = QPushButton(<span class="hljs-string">'5'</span>)  
        layout.addWidget(but)  
        but.clicked.connect(<span class="hljs-keyword">lambda</span>: self.on_click(<span class="hljs-string">'5'</span>))  
        <span class="hljs-comment">#使用个who变量，结果不正常，显示 False is pressed  </span>
        <span class="hljs-comment">#but.clicked.connect(lambda who="5": self.on_click(who))  </span>

        <span class="hljs-comment">#使用封装，partial函数  </span>
        but = QPushButton(<span class="hljs-string">'6'</span>)  
        layout.addWidget(but)  
        but.clicked.connect(partial(self.on_click, <span class="hljs-string">'6'</span>))  

        layout.addWidget(self.lbl)  
        <span class="hljs-comment">#设置布局  </span>
        self.setLayout(layout)  

    <span class="hljs-comment">#传递额外参数     </span>
    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">cliked</span><span class="hljs-params">(self)</span>:</span>  
        bu = self.sender()  
        <span class="hljs-keyword">if</span> isinstance(bu, QPushButton):  
            self.lbl.setText(<span class="hljs-string">'%s is pressed'</span> % bu.text())  
        <span class="hljs-keyword">else</span>:  
            self.lbl.setText(<span class="hljs-string">'no effect'</span>)  
    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">on_click</span><span class="hljs-params">(self, n)</span>:</span>  
        self.lbl.setText(<span class="hljs-string">'%s is pressed'</span> % n)  

<span class="hljs-keyword">if</span> __name__ == <span class="hljs-string">'__main__'</span>:          
    app = QApplication(sys.argv)  
    bu =Bu1()  
    bu.show()  
    app.exec_()   </code></pre>

三：感谢[来源](http://blog.csdn.net/fengyu09/article/details/39498777) 

---

###


## PyQt + echarts图表
    echarts绘制图标会在本地保存一个`html`文件，所以使用`PyQt`将之作为一个网页页面加载即可：
    from PyQt4.QtWebKit import *
    from PyQt4.QtGui  import *
    from PyQt4.QtCore import * 
    from pyecharts import Kline, Page
    def creat_charts():
        page = Page()
        chart_init = {
                "width": 1600,
                "height": 900,
            }
        chart = Kline("K 线图", **chart_init)
        chart.add("日K", ["2017/7/{}".format(i + 1) for i in range(31)], v1)
        page.add(chart)
        return page
    creat_charts()_render()     # 生成`render.html`文件
    self.view = QWebView()
    self.create_charts().render()
    url = QUrl("render.html")   # 需要加载`QUrl`使用字符串转化
    self.view.load(url)


## addWidget
在窗口布局的时候这玩意至关重要，因为要先创建一个框架，再往里面塞东西。而塞的方法就是`addWidget`。所以简单记录一下小年这一天经常用到的环套：

    hbox = QtGui.QHBoxLayout()
        vbox = QtGui.QVBoxLayout()
    可以通过`addWidget`来塞入`QtGui.QWidget`, `QtGui.QGroupBox`, 
`QtGui.QTableWidget`  ,`QScrollArea`等
    还可以`addWidget`诸如`QtGui.QPushButton`, `QtGui.QLabel`, 
`QtGui.QComboBox`, `QtGui.QLineEdit`等小部件

    `hbox`和`vbox`可以通过`addLayout`互相添加（这两个是 框架，即页面上的“骨头”。来摆设“肌肉”->“Widget”、"Box"等的）
    当然最后要显示谁，需要`self.setLayout(hbox)` 而支持`setLayout`少不了有
`QWidget`,`QScrollArea`, 所以它们好像能够无限互相套下去…

### 小部件的方法
其实哪些方法也不用记…打开`QtDesigner`直接搜索拖拽，然后看右边的清单就行了，但这几个还是记录下来吧，在网上找太累了~
    
`QtGui.QComboBox`: `addItems`, '''addItem`, `currentText`
`QtGui.QSpinBox`: `setValue`, 


### QString2String
    def QString2PyString(self, qStr):   
        #QString，如果内容是中文，则直接使用会有问题，要转换成 python
        #string
        return unicode(qStr.toUtf8(), 'utf-8', 'ignore')

## QLineEdit
之所以放这么后面是因为我觉得这东西没什么好说的，也就是一个输入框嘛，但因为出现在后面所以说是现在发现了其中有趣的东西。那就是最近在做输入密码的时候想要限制，但在程序中去判断显然并不是什么有意思的事情。然后想起来输入的时候可以直接限制住啊。于是采用了`textChanged`去`connect`一个函数，来动态监测输入。但在调试中打开错了窗口所以以为没有用就找了其他的方法。那就是在初始化的时候直接卡死，结果没有找到设置长度的.set***但找到了现用的`setValidator`其配合正则表达式的食用方法如下：
    
    import re
        a = QtCore.QRegExp("[A-Za-z]{0,5}[1-9][0-9]{0,5}")
        a = QtCore.QRegExp("[a-zA-Z0-9]{0,12}$")
        self.txtPasswd.setValidator(QtGui.QRegExpValidator(a))
    # emm,很显然，把a替换成limitRule就要顺眼一些了。

不过<font color=#ff3bffl9>值得注意的是：</font>如果用`setText`将其它字符写进这个编辑小框框中的话，那么这个框框的规则就会被打破然后随便写。但要是`setText`的内容没有超出所规定的形式之外的话，那么规则照旧，依然执行。

# PyQtGraph:
[Link](http://www.pyqtgraph.org/)

    import pyqtgraph.examples  
    pyqtgraph.examples.run()  
