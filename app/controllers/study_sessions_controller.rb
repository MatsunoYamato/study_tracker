class StudySessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_study_session, only: [:show, :edit, :update, :destroy]

  # GET /study_sessions
  def index
    @study_sessions = current_user.study_sessions.recent.includes(:tags)
    @pagy, @study_sessions = pagy(@study_sessions, items: 10) if defined?(Pagy)
  end

  # GET /study_sessions/1
  def show
  end

  # GET /study_sessions/new
  def new
    @study_session = current_user.study_sessions.build
    @tags = Tag.all
  end

  # GET /study_sessions/1/edit
  def edit
    @tags = Tag.all
  end

  # POST /study_sessions
  def create
    @study_session = current_user.study_sessions.build(study_session_params)
    
    if @study_session.save
      # タグの関連付け
      attach_tags(@study_session, params[:tag_ids])
      redirect_to @study_session, notice: '学習記録が作成されました。'
    else
      @tags = Tag.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_sessions/1
  def update
    if @study_session.update(study_session_params)
      # タグの関連付けを更新
      attach_tags(@study_session, params[:tag_ids])
      redirect_to @study_session, notice: '学習記録が更新されました。'
    else
      @tags = Tag.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /study_sessions/1
  def destroy
    @study_session.destroy
    redirect_to study_sessions_url, notice: '学習記録が削除されました。'
  end

  # GET /dashboard
  def dashboard
    @today_sessions = current_user.study_sessions.today.includes(:tags)
    @week_sessions = current_user.study_sessions.this_week.includes(:tags)
    @recent_sessions = current_user.study_sessions.recent.limit(5).includes(:tags)
    
    # 統計情報
    @today_total_minutes = @today_sessions.sum(:duration)
    @week_total_minutes = @week_sessions.sum(:duration)
    @total_sessions = current_user.study_sessions.count
    
    # タグ別統計
    @tag_stats = current_user.study_sessions
                            .joins(:tags)
                            .group('tags.name', 'tags.color')
                            .sum(:duration)
  end

  # PATCH /study_sessions/1/quick_record
  def quick_record
    @study_session = current_user.study_sessions.build(
      duration: 25,
      studied_at: Time.current,
      note: 'ポモドーロセッション'
    )
    
    if @study_session.save
      redirect_to dashboard_path, notice: '25分の学習記録を保存しました！'
    else
      redirect_to dashboard_path, alert: '記録の保存に失敗しました。'
    end
  end

  private

  # コールバックで使用する共通処理
  def set_study_session
    @study_session = current_user.study_sessions.find(params[:id])
  end

  # Strong Parameters: セキュリティのため許可されたパラメータのみ受け取る
  def study_session_params
    params.require(:study_session).permit(:duration, :studied_at, :note)
  end

  # タグの関連付け処理
  def attach_tags(study_session, tag_ids)
    return unless tag_ids.present?
    
    # 既存のタグ関連付けを削除
    study_session.study_session_tags.destroy_all
    
    # 新しいタグを関連付け
    tag_ids.reject(&:blank?).each do |tag_id|
      study_session.study_session_tags.create(tag_id: tag_id)
    end
  end
end