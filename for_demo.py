#!/usr/bin/env python3

#for循环示例
# 1. 遍历列表
fruits = ["apple","banana","orange"]
print("水果列表：")
for fruit in fruits:
    print(fruit)

# 2. 使用 range() 打印 0-4
print("\nrange(5):")
for i in range(5):
    print(i)

# 3. range(起始, 结束, 步长) 打印奇数
print("\n1-9 的奇数：")
for i in range(1,10,2):
    print(i)

# 4. 计算 1 到 100 的偶数和
total = 0
for i in range(2,101,2):
    total += i
print(f"\n1-100 的偶数和: {total}")

