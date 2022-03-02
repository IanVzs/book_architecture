# Markdown

## 文本字体速查表
参考自: [csdn 王大雄](https://blog.csdn.net/zgdwxp/article/details/103156841#:~:text=Markdown%20%E6%94%AF%E6%8C%81%E5%B0%86%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE%E4%B8%BA%E7%B2%97%E4%BD%93%E6%88%96%20%E6%96%9C%E4%BD%93%20%E3%80%82%20%E7%B2%97%E4%BD%93%20Markdown%20%E4%B8%AD%EF%BC%8C%E5%8F%AA%E8%A6%81%E5%9C%A8,%E6%96%87%E6%9C%AC%20%E7%9A%84%E5%89%8D%E5%90%8E%E5%8A%A0%E4%B8%A4%E4%B8%AA%20%2A%20%E6%88%96%E8%80%85%20_%20%E5%8D%B3%E5%8F%AF%E5%AE%8C%E6%88%90%E5%AD%97%E4%BD%93%20%E5%8A%A0%E7%B2%97%20%E3%80%82)
<table><thead><tr><th>样式名</th><th>效果</th><th align="left">Markdown</th></tr></thead><tbody><tr><td>加粗</td><td><strong>文本</strong></td><td align="left"><code>**文本** 或 __文本__</code>，用两个<code>*</code>或两个<code>_</code>包围文本</td></tr><tr><td>斜体</td><td><em>文本</em></td><td align="left"><code>*文本* 或 _文本_</code>，用一个<code>*</code>或一个<code>_</code>包围文本</td></tr><tr><td>删除线</td><td><s>文本</s></td><td align="left"><code>~~文本~~</code></td></tr><tr><td>下划线</td><td><u>文本</u></td><td align="left"><code>&lt;u&gt;文本&lt;/u&gt;</code>，Markdown自身没有实现下划线，但它是HTML的子集，实现了<code>&lt;u&gt;</code>标签<br> · CSDN的锚和链接是没有下划线的、只是颜色高亮，一般建议加上下划线，会更明确是链接、可点击的； <br> · 一般文本建议不要加下划线，容易误会成链接</td></tr><tr><td>上标</td><td>文本<sup>上标</sup></td><td align="left"><code>文本^上标^</code></td></tr><tr><td>下标</td><td>文本<sub>下标</sub></td><td align="left"><code>文本~下标~</code></td></tr><tr><td>小号字体</td><td><small>小号字体</small></td><td align="left"><code>&lt;small&gt;小号字体&lt;/small&gt;</code></td></tr><tr><td>大号字体</td><td><big>大号字体</big></td><td align="left"><code>&lt;big&gt;大号字体&lt;/big&gt;</code></td></tr></tbody></table>

## 高亮
```
1. 使用"`"双引, eg: `{要高亮的文本}`;
2. 使用"```" 跨行, eg:```\n{要高亮的文本}\n```;
3. HTML <mark>双引, eg: <code><mark>{要高亮的文本}<mark></code>
```

1. `要高亮的文本`
2. 见下
```
要高亮的文本
```
3. <mark>要高亮的文本<mark>
