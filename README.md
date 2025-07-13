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
- **SQLite3** (開発環境)

### フロントエンド
- **TailwindCSS 4.1** - モダンなスタイリング
- **JavaScript ES6+** - リアクティブUI
- **Turbo** - SPAライクなページ遷移
- **Stimulus** - JavaScript コントローラー

### 認証・セキュリティ
- **Devise** - ユーザー認証システム
- **CSRF Protection** - セキュリティ対策

## 📋 機能一覧

### 1. ユーザー管理
- [x] ユーザー登録・ログイン
- [x] パスワードリセット
- [x] プロフィール管理

### 2. 学習記録
- [x] 学習時間の記録（分単位）
- [x] 学習日時の設定
- [x] メモ・感想の記録
- [x] 複数タグの関連付け
- [x] 記録の編集・削除

### 3. タグ管理
- [x] カスタムタグの作成
- [x] 色分け表示
- [x] タグ別統計
- [x] プリセット色の選択

### 4. ポモドーロタイマー
- [x] 25分作業タイマー
- [x] 5分休憩タイマー
- [x] 一時停止・再開機能
- [x] プログレスバー表示
- [x] 音声・ブラウザ通知
- [x] 自動セッション保存

### 5. 統計・ダッシュボード
- [x] 日別学習時間グラフ
- [x] 週別学習時間グラフ
- [x] タグ別学習時間分析
- [x] 学習記録一覧・検索
- [x] 期間フィルタリング

### 6. UI/UX
- [x] レスポンシブデザイン
- [x] ダークテーマ
- [x] アニメーション効果
- [x] トースト通知
- [x] プロフェッショナルなランディングページ

## 🚀 セットアップ

### 必要要件
- Ruby 3.2.0+
- Node.js 18+
- PostgreSQL 13+ (本番環境)
- Git

### ローカル開発環境

1. **リポジトリのクローン**
```bash
git clone https://github.com/[your-username]/study_tracker.git
cd study_tracker
```

2. **依存関係のインストール**
```bash
# Ruby gems
bundle install

# Node.js packages
npm install
```

3. **データベースのセットアップ**
```bash
# データベース作成
rails db:create

# マイグレーション実行
rails db:migrate

# サンプルデータ投入（オプション）
rails db:seed
```

4. **環境変数の設定**
```bash
cp .env.example .env
# .envファイルを編集して必要な環境変数を設定
```

5. **サーバー起動**
```bash
# Tailwind CSS ビルド（別ターミナル）
npm run build:css -- --watch

# Railsサーバー起動
rails server
```

アプリケーションは `http://localhost:3000` でアクセス可能です。

## 📱 主要画面

### ホームページ
- プロフェッショナルなランディングページ
- 浮遊するコードブロックアニメーション
- グラデーション背景とガラスモーフィズムデザイン

### ダッシュボード
- 学習時間の統計グラフ
- 最近の学習記録
- タグ別分析

### ポモドーロタイマー
- 視覚的なタイマー表示
- プログレスバー
- 音声・ブラウザ通知
- セッション記録機能

### 学習記録管理
- 記録の一覧・検索・フィルタリング
- 詳細な記録編集
- タグによる分類

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

## 🚀 デプロイ（Render）

### 1. Renderアカウントの準備
1. [Render.com](https://render.com) でアカウント作成
2. GitHubアカウントと連携

### 2. PostgreSQLデータベースの作成
1. Renderダッシュボードで "New PostgreSQL" を選択
2. データベース名を設定（例: `devlogger-db`）
3. データベースのURLをメモ

### 3. Webサービスの作成
1. "New Web Service" を選択
2. GitHubリポジトリを選択
3. 以下の設定を行う：

```yaml
# Build Command
bundle install && npm install && rails assets:precompile && rails db:migrate

# Start Command
rails server -b 0.0.0.0 -p $PORT

# Environment Variables
RAILS_ENV=production
SECRET_KEY_BASE=[生成したキー]
DATABASE_URL=[PostgreSQLのURL]
RAILS_MASTER_KEY=[config/master.keyの内容]
```

### 4. 環境変数の設定
```bash
# SECRET_KEY_BASE生成
rails secret

# Master Key確認
cat config/master.key
```

### 5. デプロイの実行
- GitHubにプッシュすると自動でデプロイが開始
- デプロイ完了後、提供されるURLでアクセス可能

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. コミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. プルリクエストを作成

## 📝 今後の拡張予定

- [ ] 学習目標設定機能
- [ ] 学習リマインダー
- [ ] チーム学習機能
- [ ] API提供
- [ ] モバイルアプリ開発
- [ ] 学習コンテンツ推薦
- [ ] Slack/Discord連携

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 👨‍💻 作者

**Developer Portfolio**
- Portfolio: [Your Portfolio URL]
- GitHub: [@your-username](https://github.com/your-username)
- Email: your.email@example.com

## 🙏 謝辞

- [Ruby on Rails](https://rubyonrails.org/) - 素晴らしいWebフレームワーク
- [TailwindCSS](https://tailwindcss.com/) - 効率的なスタイリング
- [Devise](https://github.com/heartcombo/devise) - 認証システム
- すべてのオープンソースコントリビューター

---

<div align="center">
  <p>🚀 <strong>DevLogger</strong> でエンジニアの学習を次のレベルへ！</p>
</div>
