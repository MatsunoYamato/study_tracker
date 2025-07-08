class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @preset_tags = Tag.preset.order(:name)
    @user_tags = Tag.user_created.order(:name)
    
    # タグの使用統計を取得
    @tag_usage = current_user.study_sessions
                             .joins(:tags)
                             .group('tags.id', 'tags.name', 'tags.color')
                             .select('tags.id, tags.name, tags.color, COUNT(study_sessions.id) as usage_count, SUM(study_sessions.duration) as total_duration')
                             .order('usage_count DESC')
  end

  # GET /tags/1
  def show
    # このタグを使用した学習記録を取得
    @study_sessions = current_user.study_sessions
                                  .joins(:tags)
                                  .where(tags: { id: @tag.id })
                                  .recent
                                  .limit(20)
                                  .includes(:tags)
    
    # 統計情報
    @total_sessions = @study_sessions.count
    @total_duration = current_user.study_sessions
                                  .joins(:tags)
                                  .where(tags: { id: @tag.id })
                                  .sum(:duration)
    @average_duration = @total_sessions > 0 ? (@total_duration.to_f / @total_sessions).round(1) : 0
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
    # プリセットタグは編集不可
    if @tag.is_preset?
      redirect_to tags_path, alert: 'プリセットタグは編集できません。'
    end
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)
    @tag.is_preset = false  # ユーザー作成タグは常にfalse
    
    if @tag.save
      redirect_to @tag, notice: 'タグが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    # プリセットタグは更新不可
    if @tag.is_preset?
      redirect_to tags_path, alert: 'プリセットタグは編集できません。'
      return
    end
    
    if @tag.update(tag_params)
      redirect_to @tag, notice: 'タグが更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    # プリセットタグは削除不可
    if @tag.is_preset?
      redirect_to tags_path, alert: 'プリセットタグは削除できません。'
      return
    end
    
    # タグを使用している学習記録がある場合の確認
    usage_count = current_user.study_sessions.joins(:tags).where(tags: { id: @tag.id }).count
    
    if usage_count > 0
      redirect_to @tag, alert: "このタグは#{usage_count}個の学習記録で使用されているため削除できません。"
      return
    end
    
    @tag.destroy
    redirect_to tags_path, notice: 'タグが削除されました。'
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color, :description)
  end
end