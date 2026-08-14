#!/bin/bash
set -e

# 文件路径
SOURCE_FILE="filters/sources.txt"
OUTPUT_FILE="filters/merged.txt"

# 清空输出文件
> "$OUTPUT_FILE"

echo "开始合并规则"
# 逐行读取链接下载内容追加到合并文件
while IFS= read -r url; do
  if [[ -n "$url" ]]; then
    echo "下载: $url"
    curl -sL --connect-timeout 20 "$url" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  fi
done < "$SOURCE_FILE"

echo "合并完成"
