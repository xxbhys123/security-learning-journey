#!/bin/bash
#============================================================
# 脚本名称: check_services.sh
# 功能描述: 检查关键服务（nginx/mysql/sshd）运行状态，并尝试启动停止的服务
# 用法: ./check_services.sh
#============================================================

SERVICES="nginx mysql sshd"
RUNNING=0
STOPPED=0

echo "============================================="
echo "  📊 服务状态巡检报告"
echo "  主机: $(hostname)"
echo "  时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================="

for SERVICE in $SERVICES; do
    if systemctl is-active --quiet "$SERVICE" 2>/dev/null; then
        echo -e "\033[32m✅ $SERVICE 正在运行\033[0m"
        RUNNING=$((RUNNING + 1))
    else
        echo -e "\033[31m❌ $SERVICE 已停止，正在尝试启动...\033[0m"
        systemctl start "$SERVICE" 2>/dev/null
        STOPPED=$((STOPPED + 1))
    fi
done

echo "============================================="
echo "  运行中: $RUNNING  停止: $STOPPED"
if [ $STOPPED -gt 0 ]; then
    echo -e "  ⚠️  状态: \033[31m存在服务停止\033[0m"
else
    echo -e "  ✅ 状态: \033[32m所有服务运行正常\033[0m"
fi
echo "============================================="

