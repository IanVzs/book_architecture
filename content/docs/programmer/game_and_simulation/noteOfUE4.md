---
title: UE4 笔记
date: 2021-05-10 12:13:26
categories: [note, ue4, learning]
tags: [ue4, learning]
---
# UE4 笔记
![ue4](https://cdn2.unrealengine.com/Unreal+Engine%2Fblog%2Fconnect-with-the-unreal-engine-community-online%2FUE_Community_Online_Feed-thumb-desktop-1400x788-a6917dba2f2cc41cc1426a3afdff135521cea738.png "ue4")

## 手机
- 路径必须不能用汉字, 一律全英文(神奇...以前习惯就是全英,以为这问题是上世纪的了,测试时不知怎么就把顺手的英文换成中文了,结果就莫名中枪了)
- java8 (ue4.26.2, 之前4.25也是, 反正就找个稳定版java一直使吧, 这语言太amazing了.)
- 虽然对java版本有一定要求, 不过按照我这次的测试和使用, 觉得折腾那么久完全是汉字项目名不支持...所以java版本要求应该不是很严重

## 动画
### 事件图表&动画图表
- 事件图表: 收集动画->存储在变量中
- 动画图表: 驱动所有动作

### 事件图表
#### isValid
蓝图不知道被哪个实例持有(通用)

#### 朝向
主角本地坐标X轴正方向表正前方
1. GetVelocity
2. RotationFromXVector

3. GetControlRotaion

2,3求`Delta`.

#### 输出
- 速度
- 方向

#### 总步骤
- 向量长度获取`Speed`
- 向量方向-控制器方向获取`Direction`
- 以上2保存为变量, 交由`动画图表`

### 动画图表
**Params-Blend-Result:**
1. 获取速度,方向(看情况可多可少)
2. 将`1`输入动画混合空间
3. 输出姿势

#### State Machine
在以上一组动作中加入状态细分
- State Machine - State1-(rule)-State2...StateN
- State - (Params-Blend-Result)


### 生效
1. 角色
2. 网格体(骨骼网格体)
3. 动画-动画类-动画蓝图
