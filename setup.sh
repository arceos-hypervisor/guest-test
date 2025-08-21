#!/bin/bash

# 检查 .arceos 文件夹是否存在
if [ ! -d ".arceos" ]; then
    echo "未找到 .arceos 文件夹，正在克隆 arceos 仓库..."
    git clone https://github.com/arceos-org/arceos .arceos
    if [ $? -eq 0 ]; then
        echo ".arceos 文件夹创建成功"
    else
        echo "克隆仓库失败"
        exit 1
    fi
else
    echo ".arceos 文件夹已存在"
fi