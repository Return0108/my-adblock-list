#!/bin/bash
set -e

SOURCE_FILE="filters/sources.txt"
OUTPUT_FILE="filters/merged.txt"

> "$OUTPUT_FILE"

echo "开始合并规则"
while IFS= read -r url; do
  if [[ -n "$url" ]]; then
    # 自动给raw.githubusercontent.com链接加上ghproxy镜像
    if [[ "$url" == https://raw.githubusercontent.com/* ]]; then
      fetch_url="https://mirror.ghproxy.com/$url"
    else
      fetch_url="$url"
    fi

    echo "下载: $url"
    curl -sL --connect-timeout 25 --max-time 60 "$fetch_url" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  fi
done < "$SOURCE_FILE"

echo "合并完成"
