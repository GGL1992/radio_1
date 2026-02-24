# iOS 应用上架全流程教程

从注册开发者账号到上架 App Store 并实现订阅收费的完整指南。

---

## 目录

1. [注册 Apple 开发者账号](#一注册-apple-开发者账号)
2. [创建 App ID 和证书](#二创建-app-id-和证书)
3. [配置 GitHub Actions 自动构建](#三配置-github-actions-自动构建)
4. [在 App Store Connect 创建应用](#四在-app-store-connect-创建应用)
5. [提交审核和上架](#五提交审核和上架)
6. [配置应用内订阅](#六配置应用内订阅)
7. [实现订阅功能代码](#七实现订阅功能代码)
8. [测试订阅功能](#八测试订阅功能)
9. [常见问题](#九常见问题)

---

## 一、注册 Apple 开发者账号

### 1.1 准备工作

| 准备项 | 说明 |
|--------|------|
| Apple ID | 如果没有，去 https://appleid.apple.com 注册 |
| 信用卡/借记卡 | 用于支付 $99 年费 |
| 身份证件 | 个人账号需要身份证验证 |
| 营业执照 | 公司账号需要（可选） |

### 1.2 注册步骤

#### 步骤 1：访问开发者网站

打开 https://developer.apple.com/programs/

点击 **Enroll**（注册）按钮

#### 步骤 2：登录 Apple ID

使用你的 Apple ID 登录

#### 步骤 3：选择账号类型

| 类型 | 费用 | 说明 |
|------|------|------|
| **个人（Individual）** | $99/年 | 以个人名义发布，显示个人姓名 |
| **公司（Organization）** | $99/年 | 以公司名义发布，显示公司名称，可添加团队成员 |

推荐：个人开发者选择 **Individual** 即可

#### 步骤 4：填写个人信息

- 姓名（中文或英文）
- 地址（需与付款地址一致）
- 电话号码
- 国家/地区

#### 步骤 5：验证身份

Apple 会进行身份验证：
- 可能需要上传身份证照片
- 可能会接到 Apple 的确认电话
- 验证时间：通常 1-2 个工作日

#### 步骤 6：支付年费

- 费用：$99/年（约 ¥700）
- 支付方式：信用卡、借记卡
- 支付后立即生效或 1-2 天内生效

### 1.3 注册完成

注册成功后，你会收到确认邮件。登录 https://developer.apple.com 可以看到你的开发者账号信息。

---

## 二、创建 App ID 和证书

### 2.1 创建 App ID

#### 步骤 1：进入 Certificates 页面

访问 https://developer.apple.com/account/resources/identifiers/list

#### 步骤 2：创建新标识符

1. 点击 **+** 按钮
2. 选择 **App IDs** → Continue
3. 选择类型：**App** → Continue

#### 步骤 3：填写 App ID 信息

| 字段 | 填写内容 | 示例 |
|------|----------|------|
| Description | 应用描述（英文） | Retro Radio |
| Bundle ID | 应用包名 | com.retroladio.retro_radio |
| Team | 选择你的开发者账号 | - |

#### 步骤 4：选择能力（Capabilities）

勾选你的应用需要的能力：

| 能力 | 说明 | 是否需要 |
|------|------|----------|
| Push Notifications | 推送通知 | 可选 |
| In-App Purchase | 应用内购买 | ✅ 必须（订阅需要） |
| Background Modes | 后台模式 | ✅ 必须（音频播放） |
| - Audio, AirPlay, and Picture in Picture | 音频后台播放 | ✅ 勾选 |

点击 **Continue** → **Register**

### 2.2 创建证书

#### 步骤 1：创建证书签名请求（CSR）

**在 Mac 电脑上：**

1. 打开 **钥匙串访问**（Keychain Access）
2. 菜单栏：钥匙串访问 → 证书助理 → 从证书颁发机构请求证书...
3. 填写信息：
   - 用户电子邮件地址：你的邮箱
   - 常用名称：你的姓名
   - 请求是：保存到磁盘
4. 点击继续，保存 CSR 文件

**在 Windows 电脑上：**

使用 OpenSSL 生成 CSR：

```bash
# 安装 OpenSSL 后执行
openssl req -new -newkey rsa:2048 -nodes -keyout private.key -out CertificateSigningRequest.certSigningRequest -subj "/emailAddress=your@email.com/CN=Your Name/C=CN"
```

#### 步骤 2：创建开发证书

1. 访问 https://developer.apple.com/account/resources/certificates/list
2. 点击 **+** 按钮
3. 选择 **Apple Development** → Continue
4. 上传刚才生成的 CSR 文件
5. 点击 Continue → Download 下载证书（.cer 文件）
6. 双击安装到钥匙串

#### 步骤 3：创建发布证书

1. 点击 **+** 按钮
2. 选择 **Apple Distribution** → Continue
3. 上传 CSR 文件
4. 下载并安装证书

### 2.3 创建 Provisioning Profile

#### 步骤 1：创建开发配置文件

1. 访问 https://developer.apple.com/account/resources/profiles/list
2. 点击 **+** 按钮
3. 选择 **iOS App Development** → Continue
4. 选择 App ID → Continue
5. 选择开发证书 → Continue
6. 选择测试设备 → Continue
7. 命名 Profile → Generate → Download

#### 步骤 2：创建发布配置文件

1. 点击 **+** 按钮
2. 选择 **App Store Distribution** → Continue
3. 选择 App ID → Continue
4. 选择发布证书 → Continue
5. 命名 Profile → Generate → Download

### 2.4 导出证书为 P12 格式

**在 Mac 上：**

1. 打开钥匙串访问
2. 找到你的发布证书
3. 右键 → 导出
4. 选择 .p12 格式
5. 设置密码（记住这个密码）
6. 保存文件

**在 Windows 上：**

使用 OpenSSL：

```bash
# 将 cer 转换为 pem
openssl x509 -inform der -in distribution.cer -out distribution.pem

# 转换为 p12
openssl pkcs12 -export -out distribution.p12 -inkey private.key -in distribution.pem
```

---

## 三、配置 GitHub Actions 自动构建

### 3.1 准备 GitHub Secrets

在 GitHub 仓库中配置以下 Secrets：

**进入：Settings → Secrets and variables → Actions → New repository secret**

| Secret 名称 | 值 | 说明 |
|------------|-----|------|
| `APPLE_CERTIFICATES` | 证书 P12 文件的 Base64 | 发布证书 |
| `APPLE_CERTIFICATES_PASSWORD` | P12 密码 | 导出时设置的密码 |
| `PROVISIONING_PROFILE` | Profile 文件的 Base64 | 发布配置文件 |
| `KEYCHAIN_PASSWORD` | 临时密码 | 自定义一个随机密码 |
| `APP_STORE_CONNECT_API_KEY_ID` | API Key ID | App Store Connect API |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | App Store Connect API |
| `APP_STORE_CONNECT_API_KEY` | API Key 内容 | App Store Connect API |

### 3.2 生成 Base64 编码

**在终端中执行：**

```bash
# macOS / Linux
base64 -i distribution.p12 | pbcopy

# Windows PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("distribution.p12")) | clip
```

### 3.3 创建 App Store Connect API Key

1. 访问 https://appstoreconnect.apple.com/access/integrations/api
2. 点击 **+** 创建新密钥
3. 输入名称
4. 选择权限：**App Manager**
5. 点击 Generate
6. 记录：
   - **Issuer ID**（页面顶部）
   - **Key ID**（密钥列表中）
   - **API Key**（下载 .p8 文件，只能下载一次！）

### 3.4 更新 GitHub Actions 配置

创建 `.github/workflows/build.yml`：

```yaml
name: Flutter Build and Deploy

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build-ios-release:
    name: Build and Deploy iOS
    runs-on: macos-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
          cache: true

      - name: Get dependencies
        run: flutter pub get

      # 安装证书
      - name: Install Apple Certificate
        env:
          CERTIFICATES_P12: ${{ secrets.APPLE_CERTIFICATES }}
          CERTIFICATES_P12_PASSWORD: ${{ secrets.APPLE_CERTIFICATES_PASSWORD }}
          KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
        run: |
          # 创建临时钥匙串
          security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security default-keychain -s build.keychain
          security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          
          # 导入证书
          echo $CERTIFICATES_P12 | base64 --decode > certificate.p12
          security import certificate.p12 -k build.keychain -P "$CERTIFICATES_P12_PASSWORD" -T /usr/bin/codesign
          security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" build.keychain

      # 安装 Provisioning Profile
      - name: Install Provisioning Profile
        env:
          PROVISIONING_PROFILE: ${{ secrets.PROVISIONING_PROFILE }}
        run: |
          mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
          echo $PROVISIONING_PROFILE | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision

      # 构建 iOS
      - name: Build iOS
        run: |
          flutter build ios --release --no-codesign
          cd build/ios/archive
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner \
            -sdk iphoneos \
            -configuration Release \
            -archivePath Runner.xcarchive \
            archive

      # 导出 IPA
      - name: Export IPA
        run: |
          xcodebuild -exportArchive \
            -archivePath build/ios/archive/Runner.xcarchive \
            -exportOptionsPlist ios/ExportOptions.plist \
            -exportPath build/ios/ipa

      # 上传到 App Store Connect
      - name: Upload to App Store Connect
        env:
          API_KEY_ID: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
          ISSUER_ID: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
          API_KEY: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
        run: |
          mkdir -p ~/.appstoreconnect/private_keys
          echo "$API_KEY" > ~/.appstoreconnect/private_keys/AuthKey_$API_KEY_ID.p8
          
          xcrun altool --upload-app \
            --type ios \
            --file build/ios/ipa/Runner.ipa \
            --apiKey $API_KEY_ID \
            --apiIssuer $ISSUER_ID

      # 上传构建产物
      - name: Upload IPA
        uses: actions/upload-artifact@v4
        with:
          name: retro-radio-ios-signed
          path: build/ios/ipa/Runner.ipa

  build-android:
    name: Build Android
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
          cache: true

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: retro-radio-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

### 3.5 创建 ExportOptions.plist

在 `ios/` 目录下创建 `ExportOptions.plist`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
```

替换 `YOUR_TEAM_ID` 为你的团队 ID（在开发者账号页面查看）。

---

## 四、在 App Store Connect 创建应用

### 4.1 创建应用

1. 访问 https://appstoreconnect.apple.com
2. 点击 **我的 App**
3. 点击 **+** → **新建 App**
4. 填写信息：

| 字段 | 填写内容 |
|------|----------|
| 平台 | iOS |
| 名称 | 复古收音机 |
| 主要语言 | 简体中文 |
| 套装 ID | com.retroladio.retro_radio |
| SKU | retro_radio_001（自定义唯一标识） |
| 访问权限 | 完全访问权限 |

### 4.2 填写应用信息

#### App 信息

- **名称**：复古收音机（最多 30 字符）
- **副标题**：复古风格收听全国广播电台（最多 30 字符）
- **隐私政策 URL**：你的隐私政策页面（必须有）
- **类别**：音乐、新闻

#### 价格和销售范围

- **价格**：免费（订阅收费通过应用内购买实现）
- **销售范围**：选择上架的国家/地区

#### 截图和预览

需要提供不同设备尺寸的截图：

| 设备 | 尺寸 | 数量 |
|------|------|------|
| 6.7 英寸 | 1290 x 2796 | 至少 1 张 |
| 6.5 英寸 | 1242 x 2688 | 至少 1 张 |
| 5.5 英寸 | 1242 x 2208 | 至少 1 张 |

**截图要求：**
- PNG 或 JPEG 格式
- 必须是真实应用截图
- 不能包含模拟器边框

#### 应用描述

```
复古拟物风格收音机应用，带您重温经典收音机的温暖时光。

【主要功能】
• 收听全国广播电台 - 中央台、省级台、市级台
• 复古旋钮调谐 - 拖动调节，阻尼手感
• FM 刻度盘 - 指针动画，经典设计
• 后台播放 - 锁屏继续收听
• 收藏功能 - 收藏喜爱的电台
• 夜间模式 - 深色主题保护眼睛

【订阅会员】
订阅会员可解锁更多高级功能...

【联系我们】
邮箱：support@example.com
隐私政策：https://example.com/privacy
```

### 4.3 上传构建版本

1. 等待 GitHub Actions 构建完成
2. 上传成功后，在 App Store Connect 的 **构建版本** 中会出现新版本
3. 选择该构建版本

---

## 五、提交审核和上架

### 5.1 审核前检查清单

| 项目 | 状态 |
|------|------|
| 应用图标 | ✅ 1024 x 1024 PNG |
| 截图 | ✅ 各尺寸至少 1 张 |
| 应用描述 | ✅ 已填写 |
| 隐私政策 | ✅ 已提供 URL |
| 年龄分级 | ✅ 已完成问卷 |
| 构建版本 | ✅ 已选择 |
| 应用内购买 | ✅ 已配置（如有） |

### 5.2 提交审核

1. 在 App Store Connect 中确认所有信息已填写完整
2. 点击 **添加以供审核**
3. 等待审核（通常 1-3 天）

### 5.3 审核状态说明

| 状态 | 说明 |
|------|------|
| 准备提交 | 可以提交审核 |
| 等待审核 | 已提交，排队中 |
| 正在审核 | 审核人员正在审核 |
| 等待开发者操作 | 需要回复问题或修改 |
| 准备销售 | 审核通过，等待上架 |
| 就绪状态 | 已上架 |

### 5.4 审核被拒处理

常见拒绝原因：

| 原因 | 解决方案 |
|------|----------|
| 元数据问题 | 修改描述、截图等 |
| 功能问题 | 修复 Bug 后重新提交 |
| 设计问题 | 按照建议修改 UI |
| 隐私问题 | 完善隐私政策 |
| 应用内购买问题 | 检查 IAP 配置 |

处理方式：
1. 查看 App Store Connect 中的拒绝原因
2. 回复审核人员的问题
3. 修改后重新提交

### 5.5 上架成功

审核通过后，应用会自动上架。你可以在 App Store 搜索到你的应用。

---

## 六、配置应用内订阅

### 6.1 创建 App 内购买项目

1. 访问 App Store Connect → 你的应用 → 功能 → App 内购买项目
2. 点击 **+** 创建新项目
3. 选择类型：**订阅**

### 6.2 填写订阅信息

#### 基本信息

| 字段 | 填写内容 |
|------|----------|
| 引用名称 | 月度会员（内部标识） |
| 产品 ID | retro_radio_monthly |
| 订阅时长 | 1 个月 |

#### 订阅群组

1. 创建订阅群组：**复古收音机会员**
2. 将所有订阅添加到同一群组

#### 价格

选择价格等级：

| 产品 ID | 价格等级 | 人民币价格 |
|---------|----------|-----------|
| retro_radio_monthly | 等级 1 | ¥6/月 |
| retro_radio_yearly | 等级 10 | ¥68/年 |

#### 本地化信息

| 语言 | 显示名称 | 描述 |
|------|----------|------|
| 简体中文 | 月度会员 | 每月自动续费会员 |
| 英语 | Monthly Premium | Monthly auto-renewable subscription |

### 6.3 创建多个订阅选项

建议提供以下订阅选项：

| 类型 | 产品 ID | 价格 | 说明 |
|------|---------|------|------|
| 月度 | retro_radio_monthly | ¥6/月 | 基础订阅 |
| 年度 | retro_radio_yearly | ¥68/年 | 年付优惠（约 5 折） |

### 6.4 配置订阅界面

在 App Store Connect 中：

1. 进入 **订阅群组**
2. 配置 **订阅界面**
3. 上传宣传图片
4. 填写推广文本

### 6.5 订阅状态说明

| 状态 | 说明 |
|------|------|
| 准备提交 | 已创建，等待审核 |
| 等待审核 | 正在审核 |
| 就绪状态 | 审核通过，可使用 |
| 需要开发者操作 | 需要修改 |

---

## 七、实现订阅功能代码

### 7.1 添加依赖

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  in_app_purchase: ^3.1.13
```

### 7.2 创建订阅服务

创建 `lib/services/subscription/subscription_service.dart`：

```dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // 产品 ID
  static const String monthlySubscriptionId = 'retro_radio_monthly';
  static const String yearlySubscriptionId = 'retro_radio_yearly';

  // 可用产品
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // 当前订阅状态
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  // 初始化
  Future<void> initialize() async {
    // 检查是否可用
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('In-app purchase not available');
      return;
    }

    // 监听购买流
    final Stream<List<PurchaseDetails>> purchaseUpdated = 
        _inAppPurchase.purchaseStream;
    
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );

    // 获取产品
    await loadProducts();
    
    // 恢复购买
    await restorePurchases();
  }

  // 加载产品
  Future<void> loadProducts() async {
    final Set<String> productIds = {
      monthlySubscriptionId,
      yearlySubscriptionId,
    };

    final ProductDetailsResponse response = 
        await _inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    if (response.error != null) {
      debugPrint('Error loading products: ${response.error}');
      return;
    }

    _products = response.productDetails;
    debugPrint('Loaded ${_products.length} products');
  }

  // 购买订阅
  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Error buying subscription: $e');
    }
  }

  // 恢复购买
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  // 购买更新回调
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _handlePending(purchaseDetails);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handlePurchased(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _handleError(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          _handleCanceled(purchaseDetails);
          break;
      }

      // 完成交易
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _handlePending(PurchaseDetails purchaseDetails) {
    debugPrint('Purchase pending: ${purchaseDetails.productID}');
  }

  Future<void> _handlePurchased(PurchaseDetails purchaseDetails) async {
    debugPrint('Purchase successful: ${purchaseDetails.productID}');
    
    // 验证收据
    final bool valid = await _verifyPurchase(purchaseDetails);
    
    if (valid) {
      _isPremium = true;
      // 保存订阅状态到本地
      // await _saveSubscriptionStatus(true);
    }
  }

  void _handleError(PurchaseDetails purchaseDetails) {
    debugPrint('Purchase error: ${purchaseDetails.error}');
    _isPremium = false;
  }

  void _handleCanceled(PurchaseDetails purchaseDetails) {
    debugPrint('Purchase canceled: ${purchaseDetails.productID}');
  }

  // 验证购买（需要后端验证，这里简化处理）
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // 生产环境应该通过后端验证收据
    // 这里简化处理，直接返回 true
    return true;
  }

  void _updateStreamOnDone() {
    _subscription?.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    debugPrint('Purchase stream error: $error');
  }

  void dispose() {
    _subscription?.cancel();
  }
}
```

### 7.3 创建订阅页面

创建 `lib/features/subscription/subscription_screen.dart`：

```dart
import 'package:flutter/material.dart';
import '../../services/subscription/subscription_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('订阅会员'),
        backgroundColor: const Color(0xFFB8860B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F1A),
            ],
          ),
        ),
        child: SafeArea(
          child: _subscriptionService.isPremium
              ? _buildPremiumView()
              : _buildSubscriptionOptions(),
        ),
      ),
    );
  }

  Widget _buildPremiumView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.verified,
            size: 80,
            color: Color(0xFFB8860B),
          ),
          const SizedBox(height: 24),
          const Text(
            '您已是会员',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '感谢您的支持！',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOptions() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 标题
          const Text(
            '解锁高级功能',
            style: TextStyle(
              color: Color(0xFFB8860B),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '订阅会员，享受更多精彩内容',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 会员权益
          _buildBenefitItem('无广告体验'),
          _buildBenefitItem('离线下载无限量'),
          _buildBenefitItem('专属复古主题'),
          _buildBenefitItem('优先客服支持'),
          
          const SizedBox(height: 32),
          
          // 订阅选项
          Expanded(
            child: ListView.builder(
              itemCount: _subscriptionService.products.length,
              itemBuilder: (context, index) {
                final product = _subscriptionService.products[index];
                final isYearly = product.id.contains('yearly');
                
                return _buildSubscriptionCard(
                  product: product,
                  isRecommended: isYearly,
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 恢复购买
          TextButton(
            onPressed: () {
              _subscriptionService.restorePurchases();
            },
            child: const Text(
              '恢复购买',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          
          // 条款说明
          Text(
            '订阅将自动续费，可随时取消',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFFB8860B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required ProductDetails product,
    bool isRecommended = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isRecommended 
            ? const Color(0xFFB8860B).withValues(alpha: 0.2)
            : const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended 
              ? const Color(0xFFB8860B) 
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          if (isRecommended)
            Positioned(
              right: 16,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFB8860B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  '推荐',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _subscriptionService.buySubscription(product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8860B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('订阅'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 7.4 初始化订阅服务

在 `main.dart` 中初始化：

```dart
import 'services/subscription/subscription_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... 其他初始化代码 ...
  
  // 初始化订阅服务
  await SubscriptionService().initialize();
  
  runApp(const RetroRadioApp());
}
```

---

## 八、测试订阅功能

### 8.1 创建沙盒测试账号

1. 访问 App Store Connect → 用户和访问 → 沙盒测试员
2. 点击 **+** 创建测试账号
3. 填写信息：
   - 名字、姓氏
   - 邮箱（不能是真实 Apple ID）
   - 密码
   - 地区

### 8.2 在设备上测试

1. 在测试设备上 **退出** App Store 的真实 Apple ID
2. 运行应用
3. 触发购买
4. 使用沙盒测试账号登录
5. 确认购买（沙盒环境不会真正扣款）

### 8.3 测试订阅续期

沙盒环境中订阅时间会加速：

| 实际时长 | 沙盒时长 |
|----------|----------|
| 1 周 | 3 分钟 |
| 1 个月 | 5 分钟 |
| 2 个月 | 10 分钟 |
| 3 个月 | 15 分钟 |
| 6 个月 | 30 分钟 |
| 1 年 | 1 小时 |

### 8.4 测试场景

| 测试项 | 操作 |
|--------|------|
| 首次购买 | 点击订阅按钮，完成支付 |
| 恢复购买 | 删除重装应用，点击恢复购买 |
| 订阅续期 | 等待沙盒续期时间，检查状态 |
| 取消订阅 | 在 App Store 取消，检查状态 |
| 订阅过期 | 等待沙盒过期时间，检查状态 |

---

## 九、常见问题

### 9.1 开发者账号相关

**Q: 开发者账号到期会怎样？**
A: 应用会从 App Store 下架，订阅收入停止。需续费后重新上架。

**Q: 个人账号和公司账号有什么区别？**
A: 主要区别在于显示名称。公司账号可以添加团队成员协作开发。

**Q: 可以转让应用吗？**
A: 可以，在 App Store Connect 中发起转让请求。

### 9.2 审核相关

**Q: 审核需要多长时间？**
A: 通常 1-3 天，首次提交可能更长。

**Q: 被拒绝后怎么办？**
A: 根据拒绝原因修改，重新提交。可以在"解决方案中心"与审核人员沟通。

**Q: 可以加速审核吗？**
A: 紧急情况下可以申请加急审核，但需要合理理由。

### 9.3 订阅相关

**Q: 用户取消订阅后还能使用吗？**
A: 可以使用到当前订阅周期结束。

**Q: 如何处理退款？**
A: 用户申请退款由 Apple 处理，开发者无法直接操作。可通过服务器通知获取退款信息。

**Q: 订阅收入分成比例？**
A: 第一年 70%/30%，第二年起 85%/15%。

### 9.4 收入相关

**Q: 什么时候收到付款？**
A: Apple 在每月 7 日左右结算上月收入，满 $150 才会付款。

**Q: 如何查看收入报告？**
A: 在 App Store Connect → 销售和趋势 中查看。

**Q: 需要缴税吗？**
A: 需要，填写税务表格后 Apple 会代扣代缴。

---

## 附录：费用总结

| 项目 | 费用 |
|------|------|
| Apple 开发者账号 | $99/年 |
| 应用上架 | 免费 |
| 应用内订阅分成 | 30%（第二年起 15%） |
| Google Play 开发者账号 | $25（一次性） |

---

## 附录：时间线预估

| 阶段 | 时间 |
|------|------|
| 注册开发者账号 | 1-3 天 |
| 创建证书和配置 | 1-2 小时 |
| 配置 GitHub Actions | 1 小时 |
| 创建 App Store 应用 | 1 小时 |
| 首次提交审核 | 2-5 天 |
| 配置订阅功能 | 1-2 天 |
| 测试订阅 | 1 天 |

总计：约 **1-2 周**

---

*文档版本: 1.0.0*
*最后更新: 2024年*
