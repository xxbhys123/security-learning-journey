#!/usr/bin/env python3
# while 循环示例

# 1. 基本 while
count = 0
print("while count < 5:")
while count < 5:
    print(count)
    count += 1

# 2. 计算 1 到 100 的和
i = 1
total = 0
while i <= 100:
    total += i
    i += 1
print(f"\n1-100 的和: {total}")   # 5050

# 3. 带 break 的交互式循环
print("\n输入 'exit' 退出循环")
while True:
    user_input = input("请输入: ")
    if user_input == "exit":
        break
    print(f"你输入了: {user_input}")
