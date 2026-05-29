#!/bin/bash

echo "==== 1. 安装 Go Protobuf 插件 ===="
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
# 将 Go 的 bin 目录加入环境变量，防止找不到插件
export PATH="$PATH:$(go env GOPATH)/bin"

echo "==== 2. 同步并更新波场子模块代码 ===="
git submodule update --init --recursive --remote

echo "==== 3. 动态替换 Proto 文件包名 ===="
# 兼容 macOS 和 Linux 的 sed 原地替换语法
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS 语法
  find ./protocol -name "*.proto" -exec sed -i '' '/option go_package/ s|github.com/tronprotocol/grpc-gateway|github.com/qukuan/tronprotocol-go|g' {} +
else
  # Linux 语法
  find ./protocol -name "*.proto" -exec sed -i '/option go_package/ s|github.com/tronprotocol/grpc-gateway|github.com/qukuan/tronprotocol-go|g' {} +
fi

echo "==== 4. 编译生成 Go gRPC 代码 ===="

# 4.1 编译 API 层 (使用 source_relative，保持相对目录结构)
protoc -I ./protocol -I . \
  --go_out=. --go-grpc_out=. \
  --go_opt=paths=source_relative \
  --go-grpc_opt=paths=source_relative \
  ./protocol/api/*.proto

# 4.2 编译 Core 和 Contract 层 (使用 module 截断前缀方式)
protoc -I ./protocol -I . \
  --go_out=. \
  --go_opt=module=github.com/qukuan/tronprotocol-go \
  ./protocol/core/*.proto

protoc -I ./protocol -I . \
  --go_out=. \
  --go_opt=module=github.com/qukuan/tronprotocol-go \
  ./protocol/core/contract/*.proto

echo "==== 🎉 编译成功！请检查生成的 api 和 core 目录。 ===="