#!/bin/bash
# ============================================================
# 脚本名称: check_memory.sh
# 功能描述: 检查内存使用率，超过阈值告警
# 用法: ./check_memory.sh [阈值]
# 示例: ./check_memory.sh 85
# ============================================================

THRESHOLD=${1:-90}

HOSTNAME=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "============================================="
echo "  📊 内存巡检报告"
echo "  主机: $HOSTNAME"
echo "  时间: $DATE"
echo "  告警阈值: ${THRESHOLD}%"
echo "============================================="

TOTAL=$(free -m | awk 'NR==2 {print $2}')
USED=$(free -m | awk 'NR==2 {print $3}')
USE_PERCENT=$((USED * 100 / TOTAL))

if [ $USE_PERCENT -ge $THRESHOLD ]; then
	echo -e "\033[31m❌ [危险] 内存已用 ${USE_PERCENT}% (已用 ${USED}M / 总 ${TOTAL}M)\033[0m"
else 
	echo -e "\033[32m✅ [安全] 内存已用 ${USE_PERCENT}% (已用 ${USED}M / 总 ${TOTAL}M)\033[0m"
fi

echo "============================================="
