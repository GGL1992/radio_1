# GitHub Actions 自动构建指南

本文档详细说明如何使用 GitHub Actions 自动构建 Flutter 应用 APK。

---

## 前提条件

- 一个 GitHub 账号
- 项目代码已上传到 GitHub 仓库

---

## 步骤一：创建 GitHub 仓库

### 方法 A：在 GitHub 网站创建

1. 登录 https://github.com
2. 点击右上角 **+** → **New repository**
3. 填写信息：
   - Repository name: `retro_radio`（或你喜欢的名称）
   - 选择 **Public**（公开，可使用免费 Actions）或 **Private**
   - 勾选 **Add a README file**
4. 点击 **Create repository**

### 方法 B：使用 Git 命令推送

```bash
# 进入项目目录
cd D:\success\code\shou_yin_ji

# 初始化 Git 仓库（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "初始提交：复古收音机应用"

# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/retro_radio.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

---

## 步骤二：确认工作流文件已存在

项目已包含 GitHub Actions 配置文件：

```
.github/
└── workflows/
    └── build.yml    # 自动构建配置
```

如果文件不存在，请确保 `.github/workflows/build.yml` 文件已创建。

---

## 步骤三：触发构建

### 自动触发

每次推送到 `main` 或 `master` 分支时，GitHub Actions 会自动开始构建：

```bash
# 修改代码后提交推送
git add .
git commit -m "更新代码"
git push
```

### 手动触发

1. 打开 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 左侧选择 **Flutter Build** 工作流
4. 点击右侧 **Run workflow** 按钮
5. 选择分支，点击绿色 **Run workflow** 按钮

---

## 步骤四：查看构建状态

1. 进入 GitHub 仓库
2. 点击 **Actions** 标签
3. 可以看到所有构建记录
4. 点击某次构建查看详细日志

构建状态图标：
- 🟡 黄色：正在构建中
- 🟢 绿色：构建成功
- 🔴 红色：构建失败

---

## 步骤五：下载构建产物

### 构建成功后下载

1. 进入 GitHub 仓库
2. 点击 **Actions** 标签
3. 点击成功的构建记录
4. 滚动到页面底部 **Artifacts** 区域
5. 点击下载所需文件

### 构建产物说明

| 产物名称 | 平台 | 用途 | 可否直接安装 |
|----------|------|------|-------------|
| `retro-radio-apk` | Android | APK 安装包 | ✅ 可直接安装 |
| `retro-radio-aab` | Android | App Bundle | ❌ 用于上架商店 |
| `retro-radio-ios` | iOS 真机 | 无签名应用 | ❌ 需签名后安装 |
| `retro-radio-ios-simulator` | iOS 模拟器 | 模拟器应用 | ✅ 可在 Mac 模拟器运行 |

### iOS 构建产物使用说明

由于没有 Apple 开发者账号签名，iOS 产物有如下限制：

**`retro-radio-ios`（真机版本）**
- ❌ 无法直接安装到 iPhone/iPad
- ✅ 可交给有签名环境的人进行签名
- ✅ 可用于检查代码是否能正常编译

**`retro-radio-ios-simulator`（模拟器版本）**
- ✅ 可在 Mac 电脑的 iOS 模拟器中运行
- 使用方法：
  1. 下载并解压得到 `Runner.app`
  2. 打开 Xcode → Open Developer Tool → Simulator
  3. 拖拽 `Runner.app` 到模拟器窗口

---

## 构建流程说明

GitHub Actions 会自动执行以下步骤：

### Android 构建
```
1. Checkout code        → 检出代码
2. Set up Java          → 安装 Java 17
3. Set up Flutter       → 安装 Flutter SDK
4. Get dependencies     → 获取依赖包
5. Analyze code         → 代码分析
6. Build APK/AAB        → 构建 Android 安装包
7. Upload Artifacts     → 上传构建产物
```

### iOS 构建
```
1. Checkout code        → 检出代码
2. Set up Flutter       → 安装 Flutter SDK
3. Get dependencies     → 获取依赖包
4. Build iOS (No Codesign)  → 构建 iOS 应用（无签名）
5. Build iOS Simulator → 构建 iOS 模拟器版本
6. Create Archives      → 打包成 zip
7. Upload Artifacts     → 上传构建产物
```

整个构建过程约需 10-15 分钟（iOS 构建时间较长）。

---

## 常见问题

### 1. 构建失败：依赖下载超时

GitHub Actions 服务器在国外，通常网络良好。如遇超时，可重新触发构建。

### 2. 构建失败：代码错误

检查 Actions 日志，查看具体错误信息：
- 语法错误：修复代码后重新推送
- 依赖问题：检查 `pubspec.yaml`

### 3. Artifacts 不显示

确保构建完全成功，Artifacts 只在构建成功后显示。

### 4. APK 安装失败

- 确保手机允许安装未知来源应用
- 检查手机系统版本（需 Android 5.0+）

---

## iOS 构建说明

### 为什么 iOS 无法直接安装？

iOS 应用必须经过 Apple 签名才能安装到真机设备，签名需要：

| 要求 | 费用 | 说明 |
|------|------|------|
| Apple 开发者账号 | $99/年 | 付费会员才能签名 |
| 开发证书 | 免费（有账号后） | 用于开发测试 |
| 发布证书 | 免费（有账号后） | 用于上架 App Store |

### 无 Apple 开发者账号的替代方案

1. **使用模拟器版本**：在 Mac 电脑上使用 iOS 模拟器测试
2. **借用他人账号**：让有账号的朋友帮忙签名
3. **使用第三方签名工具**：如 AltStore（需要每 7 天重新签名）
4. **注册 Apple 开发者账号**：$99/年，可正式发布应用

### 如果有 Apple 开发者账号

需要配置以下 GitHub Secrets：

| Secret 名称 | 说明 |
|------------|------|
| `APPLE_CERTIFICATES` | 证书文件（.p12）的 Base64 编码 |
| `APPLE_CERTIFICATES_PASSWORD` | 证书密码 |
| `PROVISIONING_PROFILE` | Provisioning Profile 的 Base64 编码 |
| `KEYCHAIN_PASSWORD` | 临时钥匙串密码 |

然后修改 `build.yml` 添加签名步骤。

---

## 进阶配置

### 添加应用签名（Android 发布版）

如需正式签名发布 Android 应用，需配置签名密钥：

1. 生成签名密钥（需 Java 环境）：
```bash
keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias retro-radio
```

2. 在 GitHub 仓库设置中添加 Secrets：
   - `KEYSTORE_BASE64`: 密钥文件的 Base64 编码
   - `KEYSTORE_PASSWORD`: 密钥库密码
   - `KEY_ALIAS`: 密钥别名
   - `KEY_PASSWORD`: 密钥密码

3. 修改 `build.yml` 添加签名步骤

### 构建不同架构 APK

修改 `build.yml` 中的构建命令：

```yaml
# 分架构构建（体积更小）
- name: Build APK (split per ABI)
  run: flutter build apk --split-per-abi --release
```

输出：
- `app-armeabi-v7a-release.apk` (32位)
- `app-arm64-v8a-release.apk` (64位，推荐)

### 仅构建特定平台

可以手动触发时选择只构建特定平台：

1. 进入 Actions → Flutter Build
2. 点击 Run workflow
3. 在构建日志中查看，或修改 `build.yml` 添加输入参数

---

## 费用说明

GitHub Actions 对公开仓库**完全免费**。

私有仓库免费额度：
- 每月 2000 分钟（足够使用）
- 每次构建约消耗 5-10 分钟

---

## 总结流程图

```
┌─────────────────┐
│  本地修改代码    │
└────────┬────────┘
         │ git push
         ▼
┌─────────────────┐
│   推送到 GitHub  │
└────────┬────────┘
         │ 自动触发
         ▼
┌─────────────────────────────────────┐
│         GitHub Actions 自动构建      │
├─────────────────────────────────────┤
│  ┌─────────────┐  ┌───────────────┐ │
│  │ Android APK │  │   iOS 构建    │ │
│  │   (5分钟)    │  │   (10分钟)    │ │
│  └─────────────┘  └───────────────┘ │
│  ┌─────────────┐  ┌───────────────┐ │
│  │ Android AAB │  │ iOS Simulator │ │
│  │   (5分钟)    │  │   (5分钟)     │ │
│  └─────────────┘  └───────────────┘ │
└────────────────┬────────────────────┘
                 │ 构建完成
                 ▼
┌─────────────────────────────────────┐
│         Artifacts 下载区域           │
├─────────────────────────────────────┤
│ • retro-radio-apk         ✅ 可安装 │
│ • retro-radio-aab         📦 上架用 │
│ • retro-radio-ios         ⚠️ 需签名 │
│ • retro-radio-ios-simulator 🖥️ 模拟器│
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────┐
│   安装到设备     │
└─────────────────┘
```

---

## 需要帮助？

如果构建过程中遇到问题：
1. 查看 Actions 日志获取详细错误信息
2. 确认代码没有语法错误
3. 检查 `pubspec.yaml` 配置是否正确

---

*文档更新: 2024年*
