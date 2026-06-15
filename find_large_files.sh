#!/bin/bash
# 查找 /var/log 下大于100M且7天内修改过的 .log 文件
find /var/log -name "*.log" -size +100M -mtime -7 -exec ls -lh {} \; 2>/dev/null
