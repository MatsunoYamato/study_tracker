module ApplicationHelper
  # 分単位の時間を適切なフォーマットで表示
  def format_duration_minutes(minutes)
    return '0分' if minutes.nil? || minutes.zero?

    if minutes < 60
      "#{minutes}分"
    else
      hours = minutes / 60
      remaining_minutes = minutes % 60
      if remaining_minutes == 0
        "#{hours}時間"
      else
        "#{hours}時間#{remaining_minutes}分"
      end
    end
  end

  # ページタイトルを設定
  def page_title(title = nil)
    base_title = 'DevLogger - エンジニアの技術学習記録'
    if title.present?
      "#{title} | #{base_title}"
    else
      base_title
    end
  end

  # メタデータを設定
  def meta_description(description = nil)
    description.presence || 'DevLoggerはエンジニアの技術学習を効率的に記録・管理するWebアプリケーションです。プログラミング、クラウド、DevOpsなどの学習ログをポモドーロタイマーとタグ管理で効率化します。'
  end

  # OpenGraphメタデータを設定
  def og_image_url
    image_url('study_tracker_og.png')
  rescue StandardError
    nil
  end

  # 現在のページのパスに基づいてページタイトルを動的に生成
  def dynamic_page_title
    case controller_name
    when 'study_sessions'
      case action_name
      when 'index'
        page_title('学習記録一覧')
      when 'show'
        page_title('学習記録詳細')
      when 'new'
        page_title('新規学習記録')
      when 'edit'
        page_title('学習記録編集')
      when 'dashboard'
        page_title('ダッシュボード')
      else
        page_title('学習記録')
      end
    when 'tags'
      case action_name
      when 'index'
        page_title('タグ管理')
      when 'new'
        page_title('新規タグ作成')
      when 'edit'
        page_title('タグ編集')
      else
        page_title('タグ')
      end
    when 'pomodoro'
      page_title('ポモドーロタイマー')
    when 'registrations'
      page_title('プロフィール設定')
    when 'home'
      page_title('ホーム')
    else
      page_title
    end
  end
end
