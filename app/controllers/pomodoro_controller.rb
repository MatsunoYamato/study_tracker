class PomodoroController < ApplicationController
  before_action :authenticate_user!

  # GET /pomodoro
  def index
    @tags = Tag.all.order(:name)
    @recent_sessions = current_user.study_sessions.recent.limit(5).includes(:tags)
    @today_sessions = current_user.study_sessions.today.count
    @today_minutes = current_user.study_sessions.today.sum(:duration)
  end

  # POST /pomodoro/save_session
  def save_session
    @study_session = current_user.study_sessions.build(session_params)

    if @study_session.save
      # タグの関連付け
      attach_tags(@study_session, params[:tag_ids]) if params[:tag_ids].present?

      render json: {
        status: 'success',
        message: 'ポモドーロセッションを保存しました！',
        session_id: @study_session.id,
        duration: @study_session.duration_in_hours
      }
    else
      render json: {
        status: 'error',
        message: @study_session.errors.full_messages.join(', ')
      }
    end
  end

  private

  def session_params
    params.require(:study_session).permit(:duration, :studied_at, :note)
  end

  def attach_tags(study_session, tag_ids)
    tag_ids.reject(&:blank?).each do |tag_id|
      study_session.study_session_tags.create(tag_id: tag_id)
    end
  end
end
