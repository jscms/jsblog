jsBlog 静态博客生成系统
=======================

jsBlog 是可响应式文档/代码内容产生系统，它设想的目标如下：

目标
----

* 约定大于配置
* 简单易用
* 自洽系统(jsBlog 应用本身就是用这套系统产生的)
* Markdown文档格式
* 模板/皮肤支持
* 生成响应式文档站点
* 生成HTML5应用
* 多语言支持

模式
----

* 开发模式: 本地服务器，及时预示。
* 生产模式："编译"、优化发布静态博客web站点
* 脚手架: 新建博客站点, 新建页面...

子系统
------

* 内容转换/编译系统 see /src
* Markdown 文档格式转换系统(扩展支持响应式指令)
* 响应式指令库: https://github.com/snowyu/angular-reactable


用户目录文件结构
---------------

用户目录文件结构如下：

* index.md: 主应用入口，全局配置和站点描述
* documents/: 默认文档目录
  * index.md: 文档首页
  * 子目录:默认定义是文档的子类别，但是你也可以通过配置，来改变默认定义。
    * index.md: 该子目录的配置文件，在这里可以改变它的属性.
* assets/: 默认附加资产文件目录，里面的文件和目录会直接复制到输出目录
* layout/: 默认附加布局文件目录
* public/: 默认输出目录

文档类型
--------

* Category: 类别类型
* Asset: 资产类型
* Content: 内容类型
  * 程序
  * 文章

输出的文件
---------

* authors.json
* langs.json
* index.html
* [lang]/index.json: the subdirs and pages info in the current directory.
  * dirs:
    * name/slug:
    * title
    * summary:
    * date
    * count: integer
    * tags:
  * pages:
    * name/slug:
    * title
    * authors
    * date
    * summary:
    * tags:
* [lang]/xxx.html
  * the article content



