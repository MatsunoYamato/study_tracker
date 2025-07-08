require 'rails_helper'

RSpec.describe 'StudySessionWorkflow', type: :feature do
  let(:user) { create(:user) }
  let(:tag1) { create(:tag, name: 'Ruby', color: '#FF0000') }
  let(:tag2) { create(:tag, name: 'Rails', color: '#00FF00') }

  before do
    # Feature specではログインページからログインする
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'ログイン'
    tag1 # タグを事前に作成
    tag2
  end

  describe 'ユーザーの学習記録ワークフロー' do
    scenario 'ユーザーが新しい学習記録を作成し、編集し、削除する' do
      # 1. ダッシュボードにアクセス
      visit dashboard_path
      expect(page).to have_content('学習ダッシュボード')

      # 2. 新しい学習記録を作成
      click_link '記録を追加'
      
      expect(page).to have_content('学習記録を作成')
      
      fill_in 'study_session[duration]', with: '30'
      fill_in 'study_session[note]', with: 'Rubyの基礎を学習しました'
      
      # タグを選択
      check tag1.name
      check tag2.name
      
      click_button '作成'
      
      # 3. 作成成功を確認
      expect(page).to have_content('学習記録が作成されました')
      expect(page).to have_content('30分')
      expect(page).to have_content('Rubyの基礎を学習しました')
      expect(page).to have_content(tag1.name)
      expect(page).to have_content(tag2.name)

      # 4. 学習記録を編集
      click_link '編集'
      
      expect(page).to have_content('学習記録を編集')
      
      fill_in 'study_session[duration]', with: '45'
      fill_in 'study_session[note]', with: 'Rubyの基礎とオブジェクト指向を学習しました'
      
      # タグの選択を変更
      uncheck tag2.name
      
      click_button '更新'
      
      # 5. 編集成功を確認
      expect(page).to have_content('学習記録が更新されました')
      expect(page).to have_content('45分')
      expect(page).to have_content('Rubyの基礎とオブジェクト指向を学習しました')
      expect(page).to have_content(tag1.name)
      expect(page).not_to have_content(tag2.name)

      # 6. 学習記録を削除
      click_link '削除'
      
      expect(page).to have_content('学習記録が削除されました')
      expect(page).to have_content('学習記録一覧')
      expect(page).not_to have_content('Rubyの基礎とオブジェクト指向を学習しました')
    end

    scenario 'ユーザーが学習記録を検索・フィルタリングする' do
      # 準備: 複数の学習記録を作成
      session1 = create(:study_session, user: user, note: 'Ruby学習', duration: 30, studied_at: 1.day.ago)
      session2 = create(:study_session, user: user, note: 'Rails学習', duration: 60, studied_at: 2.days.ago)
      session3 = create(:study_session, user: user, note: 'JavaScript学習', duration: 45, studied_at: 1.week.ago)
      
      session1.tags << tag1
      session2.tags << tag2
      
      # 1. 学習記録一覧にアクセス
      visit study_sessions_path
      
      expect(page).to have_content('学習記録一覧')
      expect(page).to have_content('Ruby学習')
      expect(page).to have_content('Rails学習')
      expect(page).to have_content('JavaScript学習')

      # 2. キーワード検索
      fill_in 'keyword', with: 'Ruby'
      click_button '検索'
      
      expect(page).to have_content('Ruby学習')
      expect(page).not_to have_content('Rails学習')
      expect(page).not_to have_content('JavaScript学習')
      expect(page).to have_content('検索結果: 1件')

      # 3. 詳細検索を開く
      click_button '詳細検索'
      
      # 4. 学習時間でフィルタリング
      click_link 'リセット'
      fill_in 'duration_min', with: '45'
      click_button '検索'
      
      expect(page).to have_content('Rails学習')
      expect(page).to have_content('JavaScript学習')
      expect(page).not_to have_content('Ruby学習')

      # 5. 日付範囲でフィルタリング
      click_link 'リセット'
      fill_in 'date_from', with: 3.days.ago.to_date
      click_button '検索'
      
      expect(page).to have_content('Ruby学習')
      expect(page).to have_content('Rails学習')
      expect(page).not_to have_content('JavaScript学習')
    end

    scenario 'ユーザーがポモドーロタイマーを使用する', js: true do
      # 1. ポモドーロページにアクセス
      visit pomodoro_path
      
      expect(page).to have_content('ポモドーロタイマー')
      expect(page).to have_content('25:00')
      expect(page).to have_content('作業時間')

      # 2. 本日の統計を確認
      expect(page).to have_content('本日の記録')
      expect(page).to have_content('0回')
      expect(page).to have_content('0分')

      # 3. タイマーコントロールの存在を確認
      expect(page).to have_button('開始')
      expect(page).to have_button('リセット')
      
      # 4. 記録保存フォームの存在を確認
      expect(page).to have_css('#session-form', visible: false)
      expect(page).to have_field('note')
      
      # 5. タグ選択の存在を確認
      expect(page).to have_content(tag1.name)
      expect(page).to have_content(tag2.name)
    end

    scenario 'ユーザーがタグを管理する' do
      # 1. タグ管理ページにアクセス
      visit tags_path
      
      expect(page).to have_content('タグ管理')
      expect(page).to have_content(tag1.name)
      expect(page).to have_content(tag2.name)

      # 2. 新しいタグを作成
      click_link '新しいタグを作成'
      
      expect(page).to have_content('タグを作成')
      
      fill_in 'tag[name]', with: 'JavaScript'
      fill_in 'tag[color]', with: '#0000FF'
      
      click_button '作成'
      
      # 3. 作成成功を確認
      expect(page).to have_content('タグが作成されました')
      expect(page).to have_content('JavaScript')

      # 4. タグを編集
      within("div[data-tag-name='JavaScript']") do
        click_link '編集'
      end
      
      expect(page).to have_content('タグを編集')
      
      fill_in 'tag[name]', with: 'JavaScript & Node.js'
      
      click_button '更新'
      
      # 5. 編集成功を確認
      expect(page).to have_content('タグが更新されました')
      expect(page).to have_content('JavaScript & Node.js')

      # 6. タグを削除
      within("div[data-tag-name='JavaScript & Node.js']") do
        click_link '削除'
      end
      
      expect(page).to have_content('タグが削除されました')
      expect(page).not_to have_content('JavaScript & Node.js')
    end

    scenario 'ユーザーがプロフィールを更新する' do
      # 1. プロフィール編集ページにアクセス
      visit edit_user_registration_path
      
      expect(page).to have_content('プロフィール設定')
      expect(page).to have_content('アカウント情報')

      # 2. 学習統計の表示を確認
      expect(page).to have_content('学習統計')
      expect(page).to have_content('総学習セッション')
      expect(page).to have_content('総学習時間')

      # 3. メールアドレスを更新
      fill_in 'user[email]', with: 'newemail@example.com'
      fill_in 'user[current_password]', with: 'password'
      
      click_button '更新する'
      
      # 4. 更新成功を確認
      expect(page).to have_content('アカウント情報が更新されました')
    end
  end

  describe 'エラーハンドリング' do
    scenario '無効なデータで学習記録を作成しようとする' do
      visit new_study_session_path
      
      # 必須フィールドを空のままで送信
      fill_in 'study_session[duration]', with: ''
      fill_in 'study_session[note]', with: 'a' * 1001 # 1001文字でバリデーションエラー
      
      click_button '作成'
      
      # エラーメッセージの表示を確認
      expect(page).to have_content('学習記録を作成')
      expect(page).to have_content('を入力してください')
      expect(page).to have_content('は1000文字以内で入力してください')
    end

    scenario '他のユーザーの学習記録にアクセスしようとする' do
      other_user = create(:user)
      other_session = create(:study_session, user: other_user)
      
      # 他のユーザーの学習記録にアクセス
      visit study_session_path(other_session)
      
      # 404エラーまたはアクセス拒否を確認
      page_text = page.text
      expect(page_text.include?('見つかりません') || page_text.include?('アクセスできません')).to be true
    end
  end
end
