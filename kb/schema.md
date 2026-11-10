# 习题知识库 · 字段规范（schema v1）

> 这是给**别的 Agent**看的契约。你按这个格式产出，我们这边用一条命令入库。

## 1. 存储形态

| 文件 | 作用 | 谁写 |
|---|---|---|
| `知识库/entries.jsonl` | **唯一真相**，一行一条 JSON，只追加不改写 | `_data/kb.py` |
| `知识库/index.json` | 自动生成的索引（按时间倒序，带统计） | 自动 |
| `知识库/index.html` | 自包含浏览页（数据内联，断网可读） | 自动 |

## 2. 条目字段

| 字段 | 必填 | 类型 | 说明 |
|---|---|---|---|
| `title` | ✅ | string ≤120 | 一句话说清这条是什么。**不要用「记录」「笔记」当标题** |
| `body` | ✅ | string ≤60000 | Markdown 正文。表格、公式（`$...$`）都可以 |
| `kind` | ✅ | enum | `note` / `question` / `method` / `link` / `image` / `dialog` / `mistake` |
| `summary` | ⬜ | string ≤200 | 一句话结论（列表里显示这行） |
| `tags` | ⬜ | string[] | 建议 2–4 个，第一个用学科（`数学`/`逻辑`/`写作`/`英语`） |
| `source` | ⬜ | object | `{agent, url, at, session}`，`at` 用 ISO8601 |
| `refs` | ⬜ | object | `{questions:[], links:[], images:[]}`，题号用 `"9"` 或 `"T1"` |
| `id` | ⬜ | string | 不填则自动生成 `kb-YYYYMMDD-HHMMSS-<hash6>` |
| `hash` | ⬜ | string | 自动算 = sha1(title + "\n" + body)，用于去重 |

### kind 怎么选

| kind | 什么时候用 |
|---|---|
| `method` | 一类题的**通解**（判据、骨架、下手顺序） |
| `question` | 单道题的解析 / 变式 / 一题多解 |
| `mistake` | 错因复盘（我为什么错，下次怎么识别） |
| `link` | 外部资料、视频、文章 |
| `image` | 以图为主的材料（图放 `refs.images` 或公网 URL） |
| `dialog` | 与其他 Agent 的对话精华（会保留提问原文） |
| `note` | 以上都不是的杂项 |

## 3. 最小示例

```json
{
  "kind": "method",
  "title": "假设题通解：补上断掉的那一环",
  "summary": "结论里的新概念没被前提覆盖，那一块就是缺口",
  "tags": ["逻辑", "假设题", "通解"],
  "source": {"agent": "星际绘画", "url": "https://chat.example/abc", "at": "2026-11-11T10:00:00+08:00"},
  "refs": {"questions": ["32"], "links": [], "images": []},
  "body": "## 通解\n把结论里的**新概念**拎出来……"
}
```

## 4. 硬规则

1. **一条记录只讲一件事。** 一份对话里有 5 个结论 → 拆成 5 条，别塞成一条。
2. **标题必须是结论，不是话题。** ❌「关于假设题的讨论」 ✅「假设题先找结论里的新概念」。
3. **body 里不要写「如前所述」「上接」**——入库后条目是独立可读的。
4. **重复提交不会报错**，会返回已有 id（按 hash 去重）。所以放心重跑。
5. **不要放**：个人信息、手机号、微信截图里的头像、付费资料全文。

## 5. 校验失败会怎样

```
✗ 条目校验失败：「xxx」
  - kind 必须是 note/question/method/link/image/dialog/mistake 之一，当前 'misc'
```
错误会**指出字段名和当前值**，改完重跑即可，不会写入半条。
