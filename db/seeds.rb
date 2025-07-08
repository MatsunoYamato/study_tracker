# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# プリセットタグを作成
preset_tags = [
  { name: 'Ruby', color: '#CC342D', description: 'Ruby言語の学習' },
  { name: 'Rails', color: '#D30001', description: 'Ruby on Railsの学習' },
  { name: 'JavaScript', color: '#F7DF1E', description: 'JavaScriptの学習' },
  { name: 'HTML/CSS', color: '#E34F26', description: 'HTMLとCSSの学習' },
  { name: 'データベース', color: '#336791', description: 'SQLやデータベースの学習' },
  { name: 'アルゴリズム', color: '#4CAF50', description: 'アルゴリズムと数学の学習' },
  { name: '英語', color: '#2196F3', description: '英語の学習' },
  { name: '読書', color: '#795548', description: '技術書や専門書の読書' },
  { name: 'ポモドーロ', color: '#FF9800', description: 'ポモドーロテクニックでの学習' },
  { name: '復習', color: '#9C27B0', description: '学習内容の復習' }
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
