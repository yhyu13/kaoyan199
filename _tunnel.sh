#!/usr/bin/env bash
# 临时公网隧道（cloudflared quick tunnel，免账号、HTTPS）
# bash _tunnel.sh -d   → 后台跑，地址写进 tunnel-url.txt
set -u
PORT="${PORT:-8766}"
cd "$(dirname "$0")"
if ! curl -s -o /dev/null -m 3 "http://127.0.0.1:${PORT}/index.html"; then
  echo "[1/2] 起本地服务 :${PORT}"
  nohup python -m http.server "$PORT" --bind 127.0.0.1 > /tmp/kaoyan-httpd.log 2>&1 &
  sleep 2
else
  echo "[1/2] 本地服务已在跑"
fi
echo "[2/2] 起 cloudflared 隧道…"
if [ "${1:-}" = "-d" ]; then
  nohup cloudflared tunnel --url "http://127.0.0.1:${PORT}" --no-autoupdate > /tmp/kaoyan-cf.log 2>&1 &
  for i in $(seq 1 30); do
    U=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' /tmp/kaoyan-cf.log | head -1)
    [ -n "$U" ] && break; sleep 2
  done
  echo "$U" > tunnel-url.txt
  echo "公网地址：$U"
  echo "（地址每次重启都会变；变了就是新 origin，先「导出进度」再换）"
else
  cloudflared tunnel --url "http://127.0.0.1:${PORT}" --no-autoupdate
fi
