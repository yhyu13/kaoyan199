# 2026 管综真题刷题系统（临时公网副本）

- `index.html` — 刷题主页面
- `course.html` — 三件套阅读版（含写作四篇）
- `daily/index.html` — 本周每日习题（7 天 × 8 题，与刷题器同一套引擎）

作答数据只存在你自己的浏览器 localStorage，服务器不收任何数据。
换设备请在「统计」页「导出进度」→ 新设备「导入进度」。

`bash _tunnel.sh -d` 可起一个临时公网隧道（cloudflared，免账号）。
