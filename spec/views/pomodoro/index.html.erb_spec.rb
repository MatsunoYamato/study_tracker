require 'rails_helper'

RSpec.describe "pomodoro/index", type: :view do
  let(:user) { create(:user) }
  let(:tags) { create_list(:tag, 3) }
  let(:recent_sessions) { create_list(:study_session, 2, user: user) }

  before do
    assign(:tags, tags)
    assign(:recent_sessions, recent_sessions)
    assign(:today_sessions, 5)
    assign(:today_minutes, 150)
    
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:user_signed_in?).and_return(true)
  end

  it 'ページタイトルが表示されること' do
    render
    expect(rendered).to have_content('ポモドーロタイマー')
  end

  it 'タイマー表示が含まれること' do
    render
    expect(rendered).to have_css('#timer-display')
    expect(rendered).to have_content('25:00')
  end

  it 'タイマーコントロールボタンが表示されること' do
    render
    expect(rendered).to have_css('#start-btn', text: '開始')
    expect(rendered).to have_css('#pause-btn', text: '一時停止')
    expect(rendered).to have_css('#resume-btn', text: '再開')
    expect(rendered).to have_css('#reset-btn', text: 'リセット')
  end

  it 'プログレスバーが表示されること' do
    render
    expect(rendered).to have_css('#progress-bar')
  end

  it 'セッション保存フォームが含まれること' do
    render
    expect(rendered).to have_css('#session-form')
    expect(rendered).to have_css('#save-session-form')
  end

  it 'タグ選択チェックボックスが表示されること' do
    render
    tags.each do |tag|
      expect(rendered).to have_field('tag_ids[]', type: 'checkbox')
      expect(rendered).to have_content(tag.name)
    end
  end

  it 'ナビゲーションリンクが表示されること' do
    render
    expect(rendered).to have_link('学習記録一覧')
    expect(rendered).to have_link('ダッシュボード')
  end

  context '統計情報の表示' do
    it '本日の統計が表示されること' do
      render
      expect(rendered).to have_content('本日の記録')
      expect(rendered).to have_content('5回')
      expect(rendered).to have_content('2.5時間')
    end
  end

  context '最近の記録の表示' do
    it '最近のセッションが表示されること' do
      render
      expect(rendered).to have_content('最近の記録')
    end

    context '記録がある場合' do
      it 'セッション情報が表示されること' do
        render
        recent_sessions.each do |session|
          expect(rendered).to have_content(session.studied_at.strftime('%m/%d %H:%M'))
          expect(rendered).to have_content("#{session.duration}分")
        end
      end
    end
  end

  it 'ポモドーロテクニックの説明が表示されること' do
    render
    expect(rendered).to have_content('ポモドーロテクニック')
    expect(rendered).to have_content('25分間集中して作業')
    expect(rendered).to have_content('5分間の短い休憩')
  end

  it '必要なJavaScriptコードが含まれること' do
    render
    expect(rendered).to include('document.addEventListener(\'DOMContentLoaded\'')
    expect(rendered).to include('startTimer')
    expect(rendered).to include('pauseTimer')
    expect(rendered).to include('resumeTimer')
    expect(rendered).to include('resetTimer')
  end

  it '音声要素が含まれること' do
    render
    expect(rendered).to have_css('#timer-sound')
  end

  it 'CSRFトークンが正しく設定されること' do
    render
    expect(rendered).to include('X-CSRF-Token')
  end
end