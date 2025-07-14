# DevLogger - エンジニア向け学習記録アプリ

<div align="center">
  <img src="https://img.shields.io/badge/Ruby-3.2.0-red?style=for-the-badge&logo=ruby&logoColor=white" alt="Ruby">
  <img src="https://img.shields.io/badge/Rails-7.1.5-red?style=for-the-badge&logo=rubyonrails&logoColor=white" alt="Rails">
  <img src="https://img.shields.io/badge/TailwindCSS-4.1-blue?style=for-the-badge&logo=tailwindcss&logoColor=white" alt="TailwindCSS">
  <img src="https://img.shields.io/badge/PostgreSQL-15-blue?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
</div>

## 概要

DevLoggerは、エンジニアの技術学習時間を効率的に記録・管理するためのWebアプリケーションです。プログラミング言語やクラウド技術ごとに学習時間を整理し、ポモドーロテクニックを活用した集中学習をサポートします。

### 🎯 主な特徴

- **学習時間の記録**: 分単位での詳細な学習時間記録
- **タグ機能**: プログラミング言語・技術分野ごとの分類
- **ポモドーロタイマー**: 25分集中＋5分休憩の効率的学習サイクル
- **統計・分析**: 日別・週別の学習時間とタグ別統計の可視化
- **モダンUI**: TailwindCSSを使用したレスポンシブデザイン
- **リアルタイム通知**: ブラウザ通知とサウンド通知

## 🛠️ 技術スタック

### バックエンド
- **Ruby 3.2.0**
- **Ruby on Rails 7.1.5**
- **PostgreSQL** (本番環境)

### フロントエンド
- **TailwindCSS 4.1** - モダンなスタイリング
- **JavaScript ES6+** - リアクティブUI
- **Turbo** - SPAライクなページ遷移
- **Stimulus** - JavaScript コントローラー

### 認証・セキュリティ
- **Devise** - ユーザー認証システム
- **CSRF Protection** - セキュリティ対策

## 📋 機能一覧

### 🧑‍💼 ユーザー管理
- ユーザー登録・ログイン
- パスワードリセット
- プロフィール管理

### 📚 学習記録
- 学習時間の記録（分単位）
- 学習日時の設定
- メモ・感想の記録
- 複数タグの関連付け
- 記録の編集・削除

### 🏷️ タグ管理
- カスタムタグの作成
- 色分け表示
- タグ別統計
- プリセット色の選択

### ⏰ ポモドーロタイマー
- 25分作業タイマー
- 5分休憩タイマー
- 一時停止・再開機能
- プログレスバー表示
- 音声・ブラウザ通知
- 自動セッション保存

### 📊 統計・ダッシュボード
- 日別学習時間グラフ
- 週別学習時間グラフ
- タグ別学習時間分析
- 学習記録一覧・検索
- 期間フィルタリング

### 🎨 UI/UX
- レスポンシブデザイン
- ダークテーマ
- アニメーション効果
- トースト通知
- プロフェッショナルなランディングページ

## 🚀 セットアップ

### 必要要件
- Ruby 3.2.0+
- Node.js 18+
- PostgreSQL 13+ (本番環境)
- Git

## 📱 主要画面

### ホームページ
プロフェッショナルなランディングページ、浮遊するコードブロックアニメーション、グラデーション背景とガラスモーフィズムデザイン

### ダッシュボード
学習時間の統計グラフ、最近の学習記録、タグ別分析

### ポモドーロタイマー
視覚的なタイマー表示、プログレスバー、音声・ブラウザ通知、セッション記録機能

### 学習記録管理
記録の一覧・検索・フィルタリング、詳細な記録編集、タグによる分類

## 🔧 技術的な実装詳細

### アーキテクチャ
- **MVC パターン**: Rails標準のアーキテクチャ
- **RESTful API**: リソースベースのルーティング
- **レスポンシブデザイン**: モバイルファーストアプローチ

### データベース設計
```
Users (ユーザー)
├── StudySessions (学習記録)
├── Tags (タグ)
└── StudySessionTags (中間テーブル)
```

### セキュリティ
- CSRF protection
- パラメータストロングパラメータ
- XSS対策
- SQLインジェクション対策

### パフォーマンス最適化
- N+1クエリ対策
- 適切なインデックス設定
- アセットの最適化
- Turboによる高速ページ遷移

## 📊 テスト

```bash
# RSpecテスト実行
bundle exec rspec

# カバレッジレポート生成
COVERAGE=true bundle exec rspec
```

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. コミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. プルリクエストを作成

## 📝 今後の拡張予定

- 学習目標設定機能
- 学習リマインダー
- チーム学習機能
- API提供
- モバイルアプリ開発
- 学習コンテンツ推薦
- Slack/Discord連携

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🙏 謝辞

- [Ruby on Rails](https://rubyonrails.org/) - 素晴らしいWebフレームワーク
- [TailwindCSS](https://tailwindcss.com/) - 効率的なスタイリング
- [Devise](https://github.com/heartcombo/devise) - 認証システム
- すべてのオープンソースコントリビューター

---

<div align="center">
  <p>🚀 <strong>DevLogger</strong> でエンジニアの学習を次のレベルへ！</p>
</div>