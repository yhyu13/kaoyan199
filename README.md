# 2026 管综备考系统

- `index.html` — 入口门户（三张卡 + 本周七天 + 二维码）
- `quiz.html` — 2026 真题刷题器（55 题，三档分层、双计时、统计、错题集、艾宾浩斯）
- `course.html` — 阅读版六件套（现状体检 / 作文三类卷 / 间隙恢复 / 写作四篇 / AI 通解 / 考点库）
- `daily/` — 本周每日习题（7 天 × 8 题，总览在 `daily/index.html`）
- `wrongbook.html` — **独立错题本**：四个做题页的错题汇到一本，艾宾浩斯复习，一键复制/导出全部题目
- `wrongbook.json` — 错题本种子（Agent 可改；页面运行时会软读取）

作答数据只存在你自己浏览器 localStorage，服务器不收任何数据。
换设备请用「统计」页「导出进度 / 导入进度」；错题本用页面里的「导出 JSON / 导入」。
同一个站点下所有页面共用一个错题库（`kg2026-wrong-v1`），所以在 quiz / daily / kp / training 里答错，都会出现在 wrongbook.html。

`bash _tunnel.sh -d` 起一个临时公网隧道（cloudflared，免账号）。
