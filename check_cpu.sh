#!/bin/bash
# ============================================================
# 脚本名称: check_cpu.sh
# 功能描述: 检查 CPU 1分钟负载，超过核心数则告警
# 用法: ./check_cpu.sh
# ============================================================

HOSTNAME=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 获取数据
LOAD1=$(uptime | awk '{print $(NF-2)}')
CORE=$(nproc)

 比较（小数比较交给 awk）
IS_HIGH=$(awk -v load="$LOAD1" -v core="$CORE" 'BEGIN {print (load > core) ? 1 : 0}')

# 输出报告头
echo "============================================="
echo "  📊 CPU 负载巡检报告"
echo "  主机: $HOSTNAME"
echo "  时间: $DATE"
echo "  核心数: ${CORE} 核"
echo "  1分钟负载: ${LOAD1}"
echo "============================================="

# 判断输出
if [ $IS_HIGH -eq 1 ]; then
    echo -e "\033[31m❌ [危险] CPU 负载 ${LOAD1} 超过核心数 ${CORE}，系统过载！\033[0m"
else
    echo -e "\033[32m✅ [安全] CPU 负载 ${LOAD1} 在核心数 ${CORE} 以内，运行平稳。\033[0m"
fi
echo "============================================="


