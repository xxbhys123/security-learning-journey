#!/usr/bin/env python3
import random                     # 导入随机数模块

secret = random.randint(1, 100)   # 生成 1~100 随机整数
attempts = 0

while True:
    guess = int(input("猜一个数字: "))
    attempts = attempts + 1

    if guess < secret:
        print("太小了")
    elif guess > secret:
        print("太大了")
    else:
        print("猜中了！用了", attempts, "次")
        break
