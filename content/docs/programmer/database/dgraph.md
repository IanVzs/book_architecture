---
title: Dgraph使用小记
date: 2022-01-10 17:00:00
modify: 2022-01-01-23 15:16:17
categories: [Dgraph, 图数据库]
tags:
---

![Dgraph](https://dgraph.io/docs//images/dgraph.svg "Dgraph")


## 概念
* 以下参考自: [这里](https://zhuanlan.zhihu.com/p/157636277)
### Console
- Mutate: 突变, 结构/数据变化的时候用
- Query: 查询, Emmmm查询的时候用
- 所以看来没有`getset`了????
### Schema
管理字段(Predicate, Type, `list,lang,index`等)

## 突变
### set
内容较多, 下面单独罗列
### delete
根据`UID` 删除指定`predicate_name` 
```
{
    delete {
        <UID> <predicate_name> * .
    }
}
```
## set
### 创建
直接json给出结构和数据,即可完成创建.只不过如果有用到`@lang`时就需要去`Schema`里更新一下`字段 - 类型 ???? (Schema-Type)`的支持项
```
{
  "set": [
    {
      "food_name": "Sushi",
      "review": [
        {
          "comment": "Tastes very good",
          "comment@jp": "とても美味しい",
          "comment@ru": "очень вкусно"
        }
      ],
      "origin": [
        {
          "country": "Japan"
        }
      ]
    }
  ]
}
```
### 更新
使用和创建差不多,不过目前我已知的更新只能用UID否则都会直接创建一个相同内容的新数据出来
```
{
  "set":[
    {
      "uid": "{UID}",
      "age": 41
    }
  ]
}
```
## 查询
### has 
直接json 返回值也会按照这个格式给出,层级深浅可随意自定
```
{
  good_name(func: has(food_name)) {
    food_name
    review
  }
}
```
```
{
  good_name(func: has(food_name)) {
    food_name
    review{
      comment
    }
  }
}
```
### uid
除了上述的`has`还有很多查询内置方法,不过深度的话除了手动罗列也可通过`recurse - depth`来确定,写多了也不会多返回
```
{
  find_follower(func: uid({UID})) @recurse(depth: 4) {
    name
    age
    follows
  }
}
```
### eq&索引
需要设置`hash`索引, 如下为查询`Sushi`的`review`
*为统配 可指定`lang`, 什么都不加默认无指定lang的数据
```
{
  food_review(func: eq(food_name,"Sushi")) {
    food_name
    review {
      comment@*
    }
  }
}
```
### <>=
func|说明
:--|--:
eq|等于
lt|小于
le|小于等于
gt|大于
ge|大于等于
```
{
  authors_and_ratings(func: ge(rating, 4.0)) {
    uid
    author_name
    rating
    published {
      title
      content
      dislikes
    }
  }
}
```

## 索引
- hash 可等查询(eq), 但不支持字符串比较大小
- exact 唯一允许字符串比较(ge,gt,le,lt)查询的索引(很牛逼的样子)
- term 带有任意一个(anyofterms), 同时拥有(allofterms), 相等(eq)
```
// 多个关键字(术语)使用空格隔开即可.
// 查询大小写不敏感
// dgraph 优化机制是将全文转换为token 查询使用查询token 所以多个查询关键词会进行重排列 获取唯一token后去全文中对比. 由此查询词的顺序无关紧要
// 也就是说anyofterms&allofterms的 `1 2 3 == 3 2 1 == 2 1 3` (结果相同是理所当然的, 消耗和内部逻辑也是相同)
{
  find_tweets(func: anyofterms(tweet, "Go GraphQL")) {
    tweet
  }
}

```
