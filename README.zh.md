# material3_indicators

这是一个实现最新 **Material 3 Expressive**（表现力设计）加载和进度指示器的 Flutter 插件包。目前，Flutter 官方 SDK 尚未原生提供这些富有表现力的动态效果（如波浪状进度条和形状渐变加载器）。本插件包以高保真度和高性能实现了这些官方规范。

## 功能特性

<p align="center">
  <img src="assets/20260712-njyi.png" width="31%" alt="Expressive Loading Indicator" />
  <img src="assets/20260712-njzb.png" width="31%" alt="Wavy Linear Progress Indicator" />
  <img src="assets/20260712-njzn.png" width="31%" alt="Wavy Circular Progress Indicator" />
</p>

| 组件 | 样式 | 主要特点 |
| :--- | :--- | :--- |
| **`ExpressiveLoadingIndicator`** | 形状渐变加载器 | 采用基于弹簧物理的平滑渐变算法，在多种圆角多边形（五边形、太阳形、柔和星形、曲奇饼形、药丸形）之间不断切换并持续旋转。支持描边/填充、以及带背景卡片（Contained）等配置选项。 |
| **`WavyLinearProgressIndicator`** | 波浪状线性进度条 | 进度条以正弦波（Sine wave）的形式波动推进。波浪的两端采用了边缘包络线（Edge Envelope）衰减算法，确保波浪端点与平直的背景轨道完美平滑过渡。 |
| **`WavyCircularProgressIndicator`** | 极坐标波浪形进度环 | 采用极坐标系统，使波浪沿圆形轨迹起伏旋转。同样具备自适应边缘包络线阻尼，使曲线两端平滑融入圆弧轨道。 |

---

## 开始使用

将 `material3_indicators` 添加到您的 `pubspec.yaml` 依赖中：

```yaml
dependencies:
  material3_indicators:
    path: path/to/local/material3_indicators # 发布到 pub.dev 后可改为版本号
```

在您的 Dart 代码中导入此插件包：

```dart
import 'package:material3_indicators/material3_indicators.dart';
```

---

## 代码示例

### 1. 形状渐变加载器 (Expressive Loading Indicator)

```dart
// 基础型（无背景卡片）
const ExpressiveLoadingIndicator(
  size: 36.0,
);

// 容器型（带背景卡片）
const ExpressiveLoadingIndicator(
  contained: true,
  size: 40.0,
  containerSize: 72.0,
  morphDuration: Duration(milliseconds: 800),
);

// 自定义渐变形状队列
ExpressiveLoadingIndicator(
  shapes: [
    ExpressiveShapes.pentagon(),
    ExpressiveShapes.cookie(),
  ],
);
```

### 2. 波浪状线性进度条 (Wavy Linear Progress Indicator)

```dart
// 确定进度状态 (Determinate)
WavyLinearProgressIndicator(
  value: 0.6,
  amplitude: 4.0,
  wavelength: 24.0,
  waveSpeed: 5.0,
  strokeWidth: 4.0,
);

// 不确定进度状态 (Indeterminate)
const WavyLinearProgressIndicator(
  value: null, // 触发 M3 规范的扫过式动画
);
```

### 3. 波浪状圆形进度环 (Wavy Circular Progress Indicator)

```dart
// 确定进度状态 (Determinate)
WavyCircularProgressIndicator(
  value: 0.75,
  size: 64.0,
  amplitude: 3.0,
  frequency: 8.0, // 一圈（360度）内波峰和波谷的数量
);

// 不确定进度状态 (Indeterminate)
const WavyCircularProgressIndicator(
  value: null,
);
```

---

## 补充信息

### 自定义形状
您可以利用 `ExpressiveShapes` 类提供的各种 [StarBorder] 生成辅助函数来自定义您的渐变形状序列，也可以将任何自定义的 `ShapeBorder` 列表直接传入 `ExpressiveLoadingIndicator(shapes: [...])` 中。

### 边缘衰减算法（包络线）
为了防止波浪形在进度条边界（起点或终点）处突然折断，两种波浪指示器内部都集成了数学包络线算法。该算法会在接近末端的位置将波幅自动平滑衰减至零，从而与经典的圆角轨道端点（Round Cap）完美无缝融合。
