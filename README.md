tronprotocol-go/                 # 你的 Go 项目根目录 (github.com/qukuan/tronprotocol-go)
├── .gitignore                   # 过滤规则 (排除了系统缓存及 build.sh)
├── .gitmodules                  # 子模块配置文件 (指向波场官方 protocol 源码)
├── go.mod                       # 模块声明模块名，及 google.golang.org/protobuf 依赖
├── go.sum                       # 模块校验锁文件
├── build.sh                     # 你编写的自动化一键编译及包名动态替换脚本
│
├── google/
│   └── api/                     # 基础公共依赖 (gRPC 转换网关所必须的注解)
│       ├── annotations.proto
│       └── http.proto
│
├── protocol/                    # [Git Submodule] 官方原始波场 .proto 文件存放目录
│   ├── api/
│   └── core/
│
├── api/                         # 🌟 编译生成的 gRPC 通信控制层目录
│   ├── api.pb.go                # 包含了链上所有交互服务的请求、响应结构体定义
│   ├── api_grpc.pb.go           # 包含了 WalletClient 核心 gRPC 客户端接口及实现
│   ├── zksnark.pb.go            # 匿名零知识证明相关数据传输结构
│   └── zksnark_grpc.pb.go       # 匿名交易相关服务客户端
│
└── core/                        # 🌟 编译生成的区块数据层核心目录 (当前脚本引用核心)
    ├── Tron.pb.go               # 核心区块结构：Transaction(交易)、Block(区块)
    ├── balance_contract.pb.go   # 核心资产转账结构：TransferContract (TRX转账)
    ├── smart_contract.pb.go     # 智能合约执行结构：TriggerSmartContract (USDT转账)
    ├── account_contract.pb.go   # 账户创建、更新、冻结资产等相关合约结构
    ├── asset_issue_contract.pb.go # TRC10 资产发行相关合约结构
    ├── common.pb.go             # 包含底层通用的枚举和数据模型
    └── [其他各类合约定义].pb.go     # 投票、见证人、交易所、多签、存储等专属合约结构
