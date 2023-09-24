---
title: 数据格式笔记
date: 2021-05-10 17:05
category: [note, 数据格式, test]
tags: [数据格式]
---

## 算法图解
在线书: https://www.hello-algo.com

## 单向链表实现和反转
```py
# 单向链表实现和反转

"""
# 当前值, 下一个值
# 循环
# 将当前值赋值为下一个的值, 下一个节点值为当前节点值

# 当前节点next赋
"""
class A:
    def __init__(self, v):
        self.v = v
        self.next = None
        
class LA:
    def __init__(self):
        self.head = None
    def add(self, v):
        node = A(v)
        node.next = self.head
        self.head = node
    def print(self):
        cur = self.head
        while cur and cur.v != None:
            print(f"linkdata node v: {cur.v}")
            cur = cur.next
    def revert(self, node: A=None, head=None):
        if not head:
            cache = self.head.next
        else:
            cache = node.next
        if cache:
            pass
            # print(f"cache: {cache.v}")
        else:
            self.head = node
            self.head.next = head
            return 
        if head == None:
            node = self.head
            node.next = None
            self.revert(cache, node)
        else:
            node.next = head
            self.revert(cache, node)

if __name__ == "__main__":
    # 1234
    # 234
    ldata = LA()
    for i in (1, 2, 3, 4):
        ldata.add(i)
    ldata.print()

    print("---"*10)
    ldata.revert()
    
    ldata.print()
    
"""
>>>运行输出:
linkdata node v: 4
linkdata node v: 3
linkdata node v: 2
linkdata node v: 1
------------------------------
linkdata node v: 1
linkdata node v: 2
linkdata node v: 3
linkdata node v: 4
"""
```

## 其他
