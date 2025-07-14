# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 重複実行チェック
if Tag.where(is_preset: true).exists?
  puts 'プリセットタグは既に存在します。スキップします。'
  puts '強制的に再作成する場合は: rails db:seed:replant'
  exit
end

# プリセットタグを作成（エンジニア向け学習カテゴリ）
preset_tags = [
  # === プログラミング言語 ===
  { name: 'JavaScript', color: '#F7DF1E', description: 'JavaScript・TypeScript・Node.jsの学習' },
  { name: 'Python', color: '#3776AB', description: 'Python・Django・Flask・FastAPIの学習' },
  { name: 'Java', color: '#ED8B00', description: 'Java・Spring・JVMの学習' },
  { name: 'TypeScript', color: '#3178C6', description: 'TypeScript・型安全性・開発効率化の学習' },
  { name: 'Go', color: '#00ADD8', description: 'Go言語・Gin・高性能APIの学習' },
  { name: 'Rust', color: '#CE422B', description: 'Rust言語・Cargo・システムプログラミングの学習' },
  { name: 'C/C++', color: '#00599C', description: 'C・C++言語・システムプログラミングの学習' },
  { name: 'Kotlin', color: '#7F52FF', description: 'Kotlin・Android・JVMの学習' },
  { name: 'Swift', color: '#FA7343', description: 'Swift・iOS・macOS開発の学習' },

  # === フロントエンド ===
  { name: 'React', color: '#61DAFB', description: 'React・Next.js・Reduxの学習' },
  { name: 'Vue.js', color: '#4FC08D', description: 'Vue.js・Nuxt.js・Vuexの学習' },
  { name: 'Angular', color: '#DD0031', description: 'Angular・TypeScriptの学習' },
  { name: 'HTML/CSS', color: '#E34F26', description: 'HTML・CSS・Sass・Tailwindの学習' },

  # === モバイル開発 ===
  { name: 'iOS開発', color: '#007AFF', description: 'iOS・SwiftUI・Xcodeの学習' },
  { name: 'Android開発', color: '#3DDC84', description: 'Android・Kotlin・Jetpack Composeの学習' },
  { name: 'Flutter', color: '#02569B', description: 'Flutter・Dart・クロスプラットフォーム開発の学習' },
  { name: 'React Native', color: '#61DAFB', description: 'React Native・Expo・モバイルアプリ開発の学習' },

  # === クラウド・インフラ ===
  { name: 'AWS', color: '#FF9900', description: 'Amazon Web Services・EC2・Lambda・S3の学習' },
  { name: 'GCP', color: '#4285F4', description: 'Google Cloud Platform・BigQuery・Cloud Functionsの学習' },
  { name: 'Azure', color: '#0078D4', description: 'Microsoft Azure・Functions・Cosmos DBの学習' },
  { name: 'Docker', color: '#2496ED', description: 'Docker・Kubernetes・コンテナオーケストレーションの学習' },
  { name: 'Kubernetes', color: '#326CE5', description: 'Kubernetes・コンテナオーケストレーション・マイクロサービスの学習' },

  # === データベース ===
  { name: 'SQL', color: '#4479A1', description: 'MySQL・PostgreSQL・SQLiteの学習' },
  { name: 'NoSQL', color: '#4DB33D', description: 'MongoDB・Redis・DynamoDBの学習' },
  { name: 'データベース設計', color: '#FF6B6B', description: 'ER図・正規化・パフォーマンスチューニングの学習' },

  # === DevOps・CI/CD ===
  { name: 'Git', color: '#F05032', description: 'Git・GitHub・GitLab・バージョン管理の学習' },
  { name: 'CI/CD', color: '#326CE5', description: 'GitHub Actions・Jenkins・自動化の学習' },
  { name: '監視・ログ', color: '#E6522C', description: 'Prometheus・Grafana・ログ解析の学習' },
  { name: 'IaC', color: '#623CE4', description: 'Terraform・CloudFormation・Ansibleの学習' },

  # === テスト ===
  { name: 'ユニットテスト', color: '#25D366', description: 'Jest・pytest・JUnit・TDDの学習' },
  { name: '統合テスト', color: '#128C7E', description: 'API・データベース・統合テストの学習' },
  { name: 'E2Eテスト', color: '#075E54', description: 'Selenium・Cypress・Playwrightの学習' },

  # === セキュリティ ===
  { name: 'セキュリティ', color: '#FF3333', description: '脆弱性診断・認証認可・セキュアコーディングの学習' },
  { name: '暗号化', color: '#8B0000', description: 'SSL/TLS・ハッシュ・暗号化技術の学習' },

  # === アルゴリズム・データ構造 ===
  { name: 'アルゴリズム', color: '#9B59B6', description: '探索・ソート・最適化アルゴリズムの学習' },
  { name: 'データ構造', color: '#8E44AD', description: '配列・リスト・ツリー・グラフの学習' },
  { name: '競技プログラミング', color: '#3498DB', description: 'AtCoder・LeetCode・HackerRankの学習' },

  # === ネットワーク・API ===
  { name: 'ネットワーク', color: '#2ECC71', description: 'TCP/IP・HTTP・DNS・ネットワーク設計の学習' },
  { name: 'API設計', color: '#27AE60', description: 'REST・GraphQL・OpenAPI・マイクロサービスの学習' },

  # === 新技術・AI ===
  { name: 'AI/ML', color: '#FF9F43', description: '機械学習・深層学習・TensorFlow・PyTorchの学習' },
  { name: 'ブロックチェーン', color: '#F39801', description: 'スマートコントラクト・Web3・DAppsの学習' },
  { name: 'WebAssembly', color: '#654FF0', description: 'WebAssembly・Wasm・高性能Web開発の学習' },

  # === その他・スキル ===
  { name: 'Linux', color: '#FCC624', description: 'Linux・コマンドライン・シェルスクリプトの学習' },
  { name: 'アーキテクチャ', color: '#E74C3C', description: 'システム設計・DDD・クリーンアーキテクチャの学習' },
  { name: '技術書・ドキュメント', color: '#8B5A2B', description: '技術書・論文・公式ドキュメントの読書' },
  { name: '資格対策', color: '#059669', description: 'AWS認定・GCP認定・情報処理技術者試験の学習' }
]

puts 'プリセットタグを作成中...'

created_count = 0
skipped_count = 0

Tag.transaction do
  preset_tags.each do |tag_data|
    tag = Tag.find_or_initialize_by(name: tag_data[:name])
    
    if tag.new_record?
      tag.assign_attributes(
        color: tag_data[:color],
        description: tag_data[:description],
        is_preset: true
      )
      
      if tag.save
        puts "  ✓ #{tag.name} - 作成"
        created_count += 1
      else
        puts "  ✗ #{tag.name} - エラー: #{tag.errors.full_messages.join(', ')}"
      end
    else
      puts "  - #{tag.name} - スキップ（既存）"
      skipped_count += 1
    end
  end
end

puts ''
puts "=========================================="
puts "プリセットタグの作成が完了しました！"
puts "作成: #{created_count}件"
puts "スキップ: #{skipped_count}件"
puts "=========================================="