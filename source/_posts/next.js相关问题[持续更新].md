---
title: next.js相关问题
categories: 1/0
date: 2019-09-12 12:16:24
tags:
- next.js
- 踩坑
---

1. 自定义 webpack 配置中的 config.resolve.alias 时需要注意 next.js 本身也有配置 alias，不要直接覆盖 alias 配置。否则在自定义 document 时会遇到无法编译的情况（到 `build page：/` 这一步会一直卡住）。
```bash
$ next dev
[ wait ]  starting the development server ...
[ info ]  waiting on http://localhost:3000 ...
[ event ] client pings, but there's no entry for page: /
[ event ] build page: /
```