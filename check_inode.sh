#!/bin/bash
#============================================================
# 脚本名称: check_inode.sh
# 功能描述: 检查文件系统 inode 使用率，超过阈值告警
# 用法: ./check_inode.sh [阈值]
# 示例: ./check_inode.sh 85    # 自定义阈值85%
# 作者: ljt
# 创建日期: 2026-06-20
#============================================================

# ---------- 1. 配置区（用户可自定义） ----------
# 默认阈值，如果执行时传了参数则覆盖
THRESHOLD=${1:-80}

# ---------- 2. 获取系统信息 ----------
HOSTNAME=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# ---------- 3. 初始化计数器 ----------
DANGER_COUNT=0
TOTAL_COUNT=0

# ---------- 4. 输出报告头 ----------
clear
echo "============================================="
echo "  📊 inode 巡检报告"
echo "  主机: $HOSTNAME"
echo "  时间: $DATE"
echo "  告警阈值: ${THRESHOLD}%"
echo "============================================="

# ---------- 5. 核心检查逻辑 ----------
# 注意：用 < <(命令) 代替管道，避免子Shell陷阱
while read line; do
    # 提取第5列（IUse%），去掉 % 号
    USE=$(echo $line | awk '{print $5}' | sed 's/%//')
    # 提取第6列（挂载点）
    MOUNT=$(echo $line | awk '{print $6}')

    # 跳过空值
    if [ -z "$USE" ]; then
        continue
    fi

    # ★★★ 关键修复：跳过非纯数字的无效值（如 '-'）★★★
    # 有些特殊文件系统（如 efivars、tmpfs）的 IUse% 显示为 '-'
    # 如果不跳过，Bash 的 -ge 比较会报错 "需要整数表达式"
    if ! [[ "$USE" =~ ^[0-9]+$ ]]; then
        continue
    fi

    # 总分区数加1
    TOTAL_COUNT=$((TOTAL_COUNT + 1))

    # 判断是否超过阈值
    if [ $USE -ge $THRESHOLD ]; then
        echo -e "\033[31m❌ [危险] $MOUNT inode 已用 ${USE}%\033[0m"
        DANGER_COUNT=$((DANGER_COUNT + 1))
    else
        echo -e "\033[32m✅ [安全] $MOUNT inode 已用 ${USE}%\033[0m"
    fi
done < <(df -i | awk 'NR>1')

# ---------- 6. 统计结果 ----------
echo "============================================="
echo "  📈 统计结果"
echo "  总分区数: $TOTAL_COUNT"
echo "  危险分区: $DANGER_COUNT"
if [ $DANGER_COUNT -gt 0 ]; then
    echo -e "  ⚠️  状态: \033[31m存在异常，请及时处理！\033[0m"
else
    echo -e "  ✅ 状态: \033[32m所有 inode 状态优良\033[0m"
fi
echo "============================================="

# ---------- 7. 退出码（供其他程序调用判断） ----------
if [ $DANGER_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi
