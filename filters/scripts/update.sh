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
    TMP_FILE="${OUTPUT_FILE}.tmp"
    http_code=$(curl -sL -w "%{http_code}" -o "$TMP_FILE" --connect-timeout 25 --max-time 60 "$fetch_url" || true)
    echo "状态码: $http_code"

    # 只有临时文件存在并且大小大于0才追加内容
    if [ -f "$TMP_FILE" ] && [ -s "$TMP_FILE" ]; then
      cat "$TMP_FILE" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
    fi
    rm -f "$TMP_FILE"
  fi
done < "$SOURCE_FILE"

echo "合并完成"
