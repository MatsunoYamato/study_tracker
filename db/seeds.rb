# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# プリセットタグを作成（一般的な学習カテゴリ）
preset_tags = [
  { name: 'プログラミング', color: '#4F46E5', description: 'プログラミング全般の学習' },
  { name: '英語', color: '#DC2626', description: '英語の学習（TOEIC、英会話など）' },
  { name: '資格勉強', color: '#059669', description: '各種資格試験の勉強' },
  { name: '数学', color: '#7C3AED', description: '数学の学習' },
  { name: '読書', color: '#B45309', description: '本・論文の読書' },
  { name: '語学', color: '#0891B2', description: '外国語の学習' },
  { name: 'ビジネス', color: '#DC2626', description: 'ビジネススキルの学習' },
  { name: 'デザイン', color: '#EC4899', description: 'デザイン・アートの学習' },
  { name: '音楽', color: '#F59E0B', description: '楽器練習・音楽理論の学習' },
  { name: '健康・運動', color: '#10B981', description: '健康管理・運動の学習' },
  { name: '料理', color: '#EF4444', description: '料理・栄養学の学習' },
  { name: '研究', color: '#6366F1', description: '学術研究・論文作成' },
  { name: '復習', color: '#8B5CF6', description: '学習内容の復習・反復練習' },
  { name: 'その他', color: '#6B7280', description: 'その他の学習活動' }
]

puts "プリセットタグを作成中..."

preset_tags.each do |tag_data|
  tag = Tag.find_or_create_by(name: tag_data[:name]) do |t|
    t.color = tag_data[:color]
    t.description = tag_data[:description]
    t.is_preset = true
  end
  puts "  #{tag.name} - #{tag.persisted? ? '作成済み' : '作成'}"
end

puts "シードデータの作成が完了しました！"
