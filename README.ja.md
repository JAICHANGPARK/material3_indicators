# material3_indicators

最新の **Material 3 Expressive**（表現豊かなデザイン）ガイドラインに準拠したローディングおよび進行状況インジケーターを提供する Flutter パッケージです。現在、この表現豊かなモーション（波状のプログレストラックや形状モーフィングローダー）は Flutter コア SDK に組み込まれていません。本パッケージは、それらを極めて忠実かつ高性能に実装して提供します。

## 主な機能

<p align="center">
  <img src="assets/20260712-njyi.png" width="31%" alt="Expressive Loading Indicator" />
  <img src="assets/20260712-njzb.png" width="31%" alt="Wavy Linear Progress Indicator" />
  <img src="assets/20260712-njzn.png" width="31%" alt="Wavy Circular Progress Indicator" />
</p>

| コンポーネント | スタイル | 主な特徴 |
| :--- | :--- | :--- |
| **`ExpressiveLoadingIndicator`** | 形状モーフィングスピナー | 角丸多角形（五角形、太陽の形、ソフトバースト、クッキーの形、カプセル型）の間をスプリング物理演算に基づいて滑らかにモーフィングしながら回転し続けます。枠線/塗りつぶし、および背景カード（Contained）の有無をオプションで設定できます。 |
| **`WavyLinearProgressIndicator`** | 波状線形プログレスバー | 進行状況バーがサイン波（正弦波）を描きながら波打つように進みます。波の両端にエッジエンベロープ（減衰）処理を施し、進行中の波の端点がフラットな背景トラックと違和感なく滑らかに接続されるように設計されています。 |
| **`WavyCircularProgressIndicator`** | 極座標波状プログレスリング | 極座標系を応用し、円形の軌道に沿って波を打ちながら回転します。同様に波の両端が減衰し、円形トラックと自然に一致します。 |

---

## はじめに

`pubspec.yaml` に `material3_indicators` の依存関係を追加します：

```yaml
dependencies:
  material3_indicators:
    path: path/to/local/material3_indicators # pub.dev公開後はバージョン番号を指定可能
```

Dart ファイルでパッケージをインポートします：

```dart
import 'package:material3_indicators/material3_indicators.dart';
```

---

## コード例

### 1. 形状モーフィングローディングインジケーター (Expressive Loading Indicator)

```dart
// 基本形 (背景カードなし)
const ExpressiveLoadingIndicator(
  size: 36.0,
);

// コンテナ型 (背景カード付き)
const ExpressiveLoadingIndicator(
  contained: true,
  size: 40.0,
  containerSize: 72.0,
  morphDuration: Duration(milliseconds: 800),
);

// 遷移する形状のカスタムリスト
ExpressiveLoadingIndicator(
  shapes: [
    ExpressiveShapes.pentagon(),
    ExpressiveShapes.cookie(),
  ],
);
```

### 2. 波状線形プログレスバー (Wavy Linear Progress Indicator)

```dart
// 進捗確定状態 (Determinate)
WavyLinearProgressIndicator(
  value: 0.6,
  amplitude: 4.0,
  wavelength: 24.0,
  waveSpeed: 5.0,
  strokeWidth: 4.0,
);

// 進捗不確定状態 (Indeterminate)
const WavyLinearProgressIndicator(
  value: null, // M3仕様のスイープアニメーションが自動で再生されます
);
```

### 3. 波状円形プログレスリング (Wavy Circular Progress Indicator)

```dart
// 進捗確定状態 (Determinate)
WavyCircularProgressIndicator(
  value: 0.75,
  size: 64.0,
  amplitude: 3.0,
  frequency: 8.0, // 360度の1周の中に含まれる波の数
);

// 進捗不確定状態 (Indeterminate)
const WavyCircularProgressIndicator(
  value: null,
);
```

---

## 補足情報

### カスタムシェイプ
`ExpressiveShapes` クラスで提供されている多様な [StarBorder] ヘルパー関数を組み合わせることで、好みの形状遷移シークエンスを設計できます。また、一般的なカスタム `ShapeBorder` のリストを直接 `ExpressiveLoadingIndicator(shapes: [...])` に渡すことも可能です。

### 境界部分の減衰処理（エッジエンベロープ）
進行状況バーの境界（開始および終了地点）で波形が急激に途切れるのを防ぐため、両波状インジケーターの内部には数学的なエンベロープ（包絡線）減衰が実装されています。これにより、端点付近では自動的に波の振幅がゼロになり、標準的なトラックの丸み（Round Cap）とシームレスに結合します。
