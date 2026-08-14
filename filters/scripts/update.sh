#!/bin/bash

SOURCE_FILE="filters/sources.txt"
OUTPUT_FILE="filters/merged.txt"

> "$OUTPUT_FILE"

echo "开始合并规则"
while IFS= read -r url; do
  if [[ -n "$url" ]]; then
    if [[ "$url" == https://raw.githubusercontent.com/* ]]; then
      fetch_url="https://mirror.ghproxy.com/$url"
    else
      fetch_url="$url"
    fi

    echo "下载: $url"
    # 输出http状态码，内容写入文件
    http_code=$(curl -sL -w "%{http_code}" -o "$OUTPUT_FILE.tmp" --connect-timeout 25 --max-time 60 "$fetch_url" || true)
    echo "状态码: $http_code"
    cat "$OUTPUT_FILE.tmp" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    rm -f "$OUTPUT_FILE.tmp"
  fi
done < "$SOURCE_FILE"

echo "合并完成"
