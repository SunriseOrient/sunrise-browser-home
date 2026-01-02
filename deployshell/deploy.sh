#!/bin/bash

# 设置脚本执行模式：遇到错误退出
set -e
# 设置脚本以显示每个命令（调试模式）
set -x

# 定义变量
DIST_DIR="docs"
PROJECT_DIR="sunrise-browser-home"

# 显示当前工作目录
echo "当前工作目录: $(pwd)"

# 检查必要的环境变量是否设置
if [ -z "$PRODUCTION" ]; then
    echo "❌ 错误: PRODUCTION 环境变量未设置"
    exit 1
fi

if [ -z "$PRODUCTION_BACKUP" ]; then
    echo "❌ 错误: PRODUCTION_BACKUP 环境变量未设置"
    exit 1
fi

echo "生产目录: $PRODUCTION"
echo "备份目录: $PRODUCTION_BACKUP"

npm install
npm run build

# 步骤1: 打包 $DIST_DIR 文件夹下的所有内容为 $PROJECT_DIR.tar.gz
echo "=========================================" 
echo "步骤1: 打包 $DIST_DIR 文件夹"

if [ ! -d "$DIST_DIR" ]; then
    echo "❌ 错误: $DIST_DIR 文件夹不存在"
    exit 1
fi

# 进入 $DIST_DIR 目录并打包
cd "$DIST_DIR"
echo "正在打包 $DIST_DIR 目录内容..."
tar -czf ../$PROJECT_DIR.tar.gz .
cd ..

if [ ! -f "$PROJECT_DIR.tar.gz" ]; then
    echo "❌ 错误: 打包失败，$PROJECT_DIR.tar.gz 文件未创建"
    exit 1
fi

echo "✅ 打包完成: $PROJECT_DIR.tar.gz"
echo "文件大小: $(du -h $PROJECT_DIR.tar.gz | cut -f1)"

# 步骤2: 检查 $PRODUCTION 文件夹下是否存在 $PROJECT_DIR 文件夹
echo "=========================================" 
echo "步骤2: 检查 $PROJECT_DIR 文件夹"

if [ -d "$PRODUCTION/$PROJECT_DIR" ]; then
    echo "✅ 找到 $PROJECT_DIR 文件夹，准备备份"
    
    # 步骤3: 如果存在则备份并删除
    echo "========================================="
    echo "步骤3: 备份 $PROJECT_DIR 文件夹"
    
    # 检查备份目录是否存在，不存在则创建
    if [ ! -d "$PRODUCTION_BACKUP" ]; then
        echo "创建备份目录: $PRODUCTION_BACKUP"
        mkdir -p "$PRODUCTION_BACKUP"
    fi
    
    # 创建时间戳，用于备份文件名
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_NAME="${PROJECT_DIR}_back_${TIMESTAMP}.tar.gz"
    
    # 压缩 $PROJECT_DIR 文件夹
    echo "正在压缩 $PROJECT_DIR 文件夹为备份文件..."
    cd "$PRODUCTION"
    tar -czf "$BACKUP_NAME" $PROJECT_DIR/
    echo "移动备份文件到备份目录..."
    mv "$BACKUP_NAME" "$PRODUCTION_BACKUP/"
    
    echo "✅ 备份完成: $PRODUCTION_BACKUP/$BACKUP_NAME"
    echo "备份文件大小: $(du -h $PRODUCTION_BACKUP/$BACKUP_NAME | cut -f1)"
    
    # 删除 $PROJECT_DIR 文件夹
    echo "删除旧的 $PROJECT_DIR 文件夹..."
    rm -rf "$PRODUCTION/$PROJECT_DIR"
    
    if [ -d "$PRODUCTION/$PROJECT_DIR" ]; then
        echo "❌ 错误: $PROJECT_DIR 文件夹删除失败"
        exit 1
    fi
    
    echo "✅ $PROJECT_DIR 文件夹已删除"
else
    echo "ℹ️  $PROJECT_DIR 文件夹不存在，跳过备份步骤"
fi

# 步骤4: 移动、解压新包并清理
echo "========================================="
echo "步骤4: 部署新版本"

# 确保生产目录存在
if [ ! -d "$PRODUCTION" ]; then
    echo "创建生产目录: $PRODUCTION"
    mkdir -p "$PRODUCTION"
fi

# 移动压缩包到生产目录
echo "移动 $PROJECT_DIR.tar.gz 到生产目录..."
mv $PROJECT_DIR.tar.gz "$PRODUCTION/"

# 进入生产目录
cd "$PRODUCTION"

# 解压压缩包
echo "正在解压 $PROJECT_DIR.tar.gz..."
tar -xzf $PROJECT_DIR.tar.gz

# 检查解压后的内容
echo "解压后的文件和文件夹:"
ls -la

# 如果解压后没有 $PROJECT_DIR 文件夹，创建一个
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ℹ️  解压后没有 $PROJECT_DIR 文件夹，创建 $PROJECT_DIR 文件夹..."
    mkdir $PROJECT_DIR
    # 将解压的内容移动到 $PROJECT_DIR 文件夹
    echo "将文件移动到 $PROJECT_DIR 文件夹..."
    shopt -s extglob  # 启用扩展模式
    mv !($PROJECT_DIR) $PROJECT_DIR/ 2>/dev/null || true
    shopt -u extglob  # 禁用扩展模式
fi

# 删除压缩包
echo "删除压缩包 $PROJECT_DIR.tar.gz..."
rm -f $PROJECT_DIR.tar.gz

echo "========================================="
echo "✅ 部署完成!"
echo "新版本已部署到: $PRODUCTION/$PROJECT_DIR"