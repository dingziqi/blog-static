---
id: trouble-shooting-in-github-action
title: github的action功能实践中的问题
categories: 0/1
date: 2019-09-17 19:28:06
tags:
  - 踩坑
---

最近 Github 终于给我安排上了新出的 Action 的 beta 测试，这是 Github 官方推出的 CI 功能，类似我之前使用过的 [travis-ci](https://travis-ci.org/)。同样是 CI，Github 的又有什么不同的地方呢？Github 利用它是最大的代码托管平台的优势，提出了将通用的构建过程抽离成包托管到 Github 平台中，从而实现复用。这些抽象出来的包被称之为 `action`，Github 也建立了一个包管理平台 [action marketplace](https://github.com/marketplace)。网上已经有大量的介绍 Github Action 的文章了，我这里就不赘述了，只让大家有个大概的概念就行。

## git push 报错
我用 Github Action 做的一个实践就是将原来位于 travis-ci 中的自动构建和发布这个博客的功能迁移过来。本博客是使用 hexo 实现的静态博客，它的构建和发布教程网上也是一堆大堆，所以这里我也不会介绍。迁移到 Github Action 后，我遇到了一个问题。在 CI 容器中执行的 git push 操作报错了，具体的错误如下：
```bash
fatal: could not read Username for 'https://github.com': No such device or address
```
在网上 google 了一下发现基本都说是由 git repo 使用的是 https 的方式导致的，只需要更改成 ssh 的方式即可。随便说下之前在 travis-ci 上也是使用 ssh + github access_token 来提交的。由于 access_token 这种是比较私密的数据，在 travis-ci 中是通过在其平台设置环境变量来实现在代码中不硬编码入 access_token。在 Github 教程中，我并没有找到哪里设置环境变量。不过经过我一番 google 后，终于找到了设置环境变量的方式。

1. 设置环境变量：
  打开对应项目的 `setting` => `Secrets` 。在这里你添加的 secret 就可以在 action 中使用。
2. 使用环境变量：
  修改对应的 `xx.yml` 中的 step。增加 env 项，可以将你的环境变量值关联到对应的 secret，语法是:
  ```
   ${{ secrets.secretKey }}
  ```
  ```yml
  ...
  - name: Deploy
  - env:
        TOKEN: ${{ secrets.TOKEN }}
     run: |
        git push -u -f https://dingziqi:${blog-static}@github.com/dingziqi/blog-static.git HEAD:gh-pages
  ```

使用 secret 不仅是私密数据没有硬编码进源码中，并且如果 log 在 action 中的日志中也会以 `***` 这种不可读的方式展示。