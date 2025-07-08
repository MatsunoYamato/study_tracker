module ApplicationHelper
  # 分単位の時間を適切なフォーマットで表示
  def format_duration_minutes(minutes)
    return '0分' if minutes.nil? || minutes.zero?

    if minutes < 60
      "#{minutes}分"
    else
      hours = minutes / 60.0
      "#{hours.round(1)}時間"
    end
  end

  # ページタイトルを設定
  def page_title(title = nil)
    base_title = 'StudyTracker - 学習記録管理アプリ'
    if title.present?
      "#{title} | #{base_title}"
    else
      base_title
    end
  end

  # メタデータを設定
  def meta_description(description = nil)
    description.presence || 'StudyTrackerは学習記録を効率的に管理するWebアプリケーションです。ポモドーロタイマー、タグ管理、統計機能で学習効率を向上させます。'
  end

  # OpenGraphメタデータを設定
  def og_image_url
    image_url('study_tracker_og.png')
  rescue
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
