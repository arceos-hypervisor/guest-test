#!/bin/bash

LIST=x86_64,aarch64

./setup.sh

# 删除 release-pkg 文件夹（如果存在）
echo "删除旧的 release-pkg 文件夹..."
rm -rf release-pkg

# 创建新的 release-pkg 文件夹
echo "创建新的 release-pkg 文件夹..."
mkdir -p release-pkg

# 将 LIST 转换为数组
IFS=',' read -ra ARCH_ARRAY <<< "$LIST"

# 遍历每个架构
for arch in "${ARCH_ARRAY[@]}"; do
    echo "=== 处理架构: $arch ==="
    
    # 执行 clean.sh
    echo "执行清理操作..."
    if [ -f clean.sh ]; then
        bash clean.sh
        if [ $? -ne 0 ]; then
            echo "错误: clean.sh 执行失败"
            exit 1
        fi
    else
        echo "警告: clean.sh 文件不存在"
    fi
    
    # 执行对应的构建脚本
    build_script="build-${arch}.sh"
    echo "执行构建脚本: $build_script"
    if [ -f "$build_script" ]; then
        bash "$build_script"
        if [ $? -ne 0 ]; then
            echo "错误: $build_script 执行失败"
            exit 1
        fi
    else
        echo "错误: $build_script 文件不存在"
        exit 1
    fi
    
    # 移动当前架构生成的 .bin 文件到 release-pkg 文件夹
    echo "移动 $arch 架构生成的 .bin 文件..."
    bin_files=$(find . -maxdepth 1 -name "*.bin" -type f)
    if [ -n "$bin_files" ]; then
        for bin_file in $bin_files; do
            echo "移动: $bin_file -> release-pkg/"
            mv "$bin_file" release-pkg/
        done
        echo "$arch 架构的 .bin 文件已移动到 release-pkg/ 文件夹"
    else
        echo "警告: $arch 架构构建后没有找到 .bin 文件"
    fi
    
    echo "架构 $arch 构建完成"
done

echo "=== 发布打包完成 ==="
echo "查看 release-pkg 文件夹内容:"
ls -la release-pkg/

# 压缩 release-pkg 文件夹为 zip 文件
echo "=== 压缩 release-pkg 文件夹 ==="
if [ -d "release-pkg" ] && [ "$(ls -A release-pkg)" ]; then
    # 删除旧的压缩包（如果存在）
    if [ -f "release-pkg.zip" ]; then
        echo "删除旧的压缩包: release-pkg.zip"
        rm -f "release-pkg.zip"
    fi
    
    echo "正在创建压缩包: release-pkg.zip"
    zip -r "release-pkg.zip" release-pkg/
    
    if [ $? -eq 0 ]; then
        echo "压缩包创建成功: release-pkg.zip"
        echo "压缩包大小: $(du -h "release-pkg.zip" | cut -f1)"
    else
        echo "错误: 压缩包创建失败"
        exit 1
    fi
else
    echo "警告: release-pkg 文件夹为空或不存在，跳过压缩"
fi

echo "=== 发布流程全部完成 ==="