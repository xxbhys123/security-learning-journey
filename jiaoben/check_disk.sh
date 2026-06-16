#!/bin/bash
# ============================================================
# 脚本名称: check_disk.sh
# 功能描述: 检查所有分区磁盘使用率，超过阈值则红色告警并统计
# 用法: ./check_disk.sh [阈值]
# 示例: ./check_disk.sh 85    # 自定义阈值85%
# 作者: 你的名字
# 创建日期: 2026-06-16
# ============================================================

# ---------- 1. 配置区（用户可自定义） ----------
# 默认阈值，如果执行时传了参数则覆盖
THRESHOLD=${1:-80}

# ---------- 2. 获取系统信息 ----------
HOSTNAME=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# ---------- 3. 初始化计数器 ----------
DANGER_COUNT=0   # 危险分区数量
TOTAL_COUNT=0    # 总分区数量

# ---------- 4. 输出报告头 ----------
clear
echo "============================================="
echo "  📊 磁盘巡检报告"
echo "  主机: $HOSTNAME"
echo "  时间: $DATE"
echo "  告警阈值: ${THRESHOLD}%"
echo "============================================="

# ---------- 5. 核心检查逻辑 ----------
# 注意：这里用了 awk 'NR>1'（不是 '{NR>1}'）
while read line; do
    # 提取第5列（使用率）并去掉 %
    USE=$(echo $line | awk '{print $5}' | sed 's/%//')
    # 提取第6列（挂载点）
    MOUNT=$(echo $line | awk '{print $6}')
    # 提取第2列（总容量）
    SIZE=$(echo $line | awk '{print $2}')

    # 跳过空行或无效行
    if [ -z "$USE" ]; then
        continue
    fi

    # 总数加1（这里用局部变量累加，后面会通过文件传递）
    TOTAL_COUNT=$((TOTAL_COUNT + 1))

    # 判断是否超过阈值
    if [ $USE -ge $THRESHOLD ]; then
        # 红色警告（\033[31m 红色，\033[0m 重置）
        echo -e "\033[31m❌ [危险] $MOUNT 已用 ${USE}% (总容量 $SIZE) ⚠️\033[0m"
        # 危险数量加1
        DANGER_COUNT=$((DANGER_COUNT + 1))
    else
        # 绿色安全
        echo -e "\033[32m✅ [安全] $MOUNT 已用 ${USE}% (总容量 $SIZE)\033[0m"
    fi
done < <(df -h | awk 'NR>1')

# ---------- 6. 统计结果 ----------
echo "============================================="
echo "  📈 统计结果"
echo "  总分区数: $TOTAL_COUNT"
echo "  危险分区: $DANGER_COUNT"
if [ $DANGER_COUNT -gt 0 ]; then
    echo -e "  ⚠️  状态: \033[31m存在异常，请及时处理！\033[0m"
else
    echo -e "  ✅ 状态: \033[32m所有磁盘状态优良\033[0m"
fi
echo "============================================="

# ---------- 7. 退出码（供其他程序调用判断） ----------
if [ $DANGER_COUNT -gt 0 ]; then
    exit 1   # 有危险，返回非0
else
    exit 0   # 一切正常，返回0
fi
