require 'rails_helper'

RSpec.describe 'StudySessions', type: :request do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }
  let(:study_session) { create(:study_session, user: user) }

  before do
    sign_in user
  end

  describe 'GET /study_sessions' do
    let!(:session1) { create(:study_session, user: user, note: 'Ruby学習') }
    let!(:session2) { create(:study_session, user: user, note: 'JavaScript学習') }

    it '正常にレスポンスが返されること' do
      get study_sessions_path
      expect(response).to have_http_status(:success)
    end

    context '検索・フィルター機能' do
      it 'キーワード検索が機能すること' do
        get study_sessions_path, params: { keyword: 'Ruby' }
        expect(response.body).to include('Ruby学習')
        expect(response.body).not_to include('JavaScript学習')
      end

      it '日付範囲での絞り込みが機能すること' do
        create(:study_session, user: user, studied_at: 1.week.ago)
        new_session = create(:study_session, user: user, studied_at: 1.day.ago)

        get study_sessions_path, params: {
          date_from: 2.days.ago.to_date.to_s
        }
        expect(response.body).to include(new_session.note)
      end

      it 'タグでの絞り込みが機能すること' do
        session1.tags << tag

        get study_sessions_path, params: { tag_ids: [tag.id] }
        expect(response).to have_http_status(:success)
      end

      it '学習時間での絞り込みが機能すること' do
        create(:study_session, user: user, duration: 10)
        create(:study_session, user: user, duration: 60)

        get study_sessions_path, params: { duration_min: 30 }
        expect(response).to have_http_status(:success)
      end

      it '並び替えが機能すること' do
        get study_sessions_path, params: { sort: 'duration_desc' }
        expect(response).to have_http_status(:success)
      end

      it '複数の検索条件を組み合わせて使用できること' do
        get study_sessions_path, params: {
          keyword: 'Ruby',
          duration_min: 10,
          sort: 'date_desc'
        }
        expect(response).to have_http_status(:success)
      end
    end

    context '検索結果の表示' do
      it '検索条件がある場合に検索結果数が表示されること' do
        get study_sessions_path, params: { keyword: 'Ruby' }
        expect(response.body).to include('検索結果:')
      end

      it '検索条件がない場合は検索結果表示がないこと' do
        get study_sessions_path
        expect(response.body).not_to include('検索結果:')
      end
    end

    context '未認証ユーザーの場合' do
      before do
        sign_out user
      end

      it 'ログインページにリダイレクトされること' do
        get study_sessions_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /study_sessions/new' do
    it '正常にレスポンスが返されること' do
      get new_study_session_path
      expect(response).to have_http_status(:success)
    end

    it '新規作成フォームが表示されること' do
      get new_study_session_path
      expect(response.body).to include('学習記録を作成')
    end
  end

  describe 'POST /study_sessions' do
    let(:valid_params) do
      {
        study_session: {
          duration: 30,
          studied_at: Time.current,
          note: 'テスト学習'
        },
        tag_ids: [tag.id]
      }
    end

    context '有効なパラメータの場合' do
      it 'セッションが作成されること' do
        expect do
          post study_sessions_path, params: valid_params
        end.to change(StudySession, :count).by(1)
      end

      it 'タグが関連付けられること' do
        post study_sessions_path, params: valid_params
        session = StudySession.last
        expect(session.tags).to include(tag)
      end

      it '詳細ページにリダイレクトされること' do
        post study_sessions_path, params: valid_params
        expect(response).to redirect_to(StudySession.last)
      end

      it '成功メッセージが表示されること' do
        post study_sessions_path, params: valid_params
        follow_redirect!
        expect(response.body).to include('学習記録が作成されました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          study_session: {
            duration: nil,
            studied_at: nil,
            note: ''
          }
        }
      end

      it 'セッションが作成されないこと' do
        expect do
          post study_sessions_path, params: invalid_params
        end.not_to change(StudySession, :count)
      end

      it '新規作成フォームが再表示されること' do
        post study_sessions_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('学習記録を作成')
      end
    end
  end

  describe 'GET /study_sessions/:id' do
    it '正常にレスポンスが返されること' do
      get study_session_path(study_session)
      expect(response).to have_http_status(:success)
    end

    it 'セッション詳細が表示されること' do
      get study_session_path(study_session)
      expect(response.body).to include(study_session.note)
    end

    context '他のユーザーのセッションの場合' do
      let(:other_user) { create(:user) }
      let(:other_session) { create(:study_session, user: other_user) }

      it 'アクセスできないこと' do
        get study_session_path(other_session)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /study_sessions/:id/edit' do
    it '正常にレスポンスが返されること' do
      get edit_study_session_path(study_session)
      expect(response).to have_http_status(:success)
    end

    it '編集フォームが表示されること' do
      get edit_study_session_path(study_session)
      expect(response.body).to include('学習記録を編集')
    end
  end

  describe 'PATCH /study_sessions/:id' do
    let(:update_params) do
      {
        study_session: {
          duration: 45,
          note: '更新されたメモ'
        },
        tag_ids: [tag.id]
      }
    end

    context '有効なパラメータの場合' do
      it 'セッションが更新されること' do
        patch study_session_path(study_session), params: update_params
        study_session.reload
        expect(study_session.duration).to eq(45)
        expect(study_session.note).to eq('更新されたメモ')
      end

      it 'タグが更新されること' do
        patch study_session_path(study_session), params: update_params
        study_session.reload
        expect(study_session.tags).to include(tag)
      end

      it '詳細ページにリダイレクトされること' do
        patch study_session_path(study_session), params: update_params
        expect(response).to redirect_to(study_session)
      end

      it '成功メッセージが表示されること' do
        patch study_session_path(study_session), params: update_params
        follow_redirect!
        expect(response.body).to include('学習記録が更新されました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          study_session: {
            duration: nil,
            note: ''
          }
        }
      end

      it 'セッションが更新されないこと' do
        original_duration = study_session.duration
        patch study_session_path(study_session), params: invalid_params
        study_session.reload
        expect(study_session.duration).to eq(original_duration)
      end

      it '編集フォームが再表示されること' do
        patch study_session_path(study_session), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('学習記録を編集')
      end
    end
  end

  describe 'DELETE /study_sessions/:id' do
    it 'セッションが削除されること' do
      session_to_delete = create(:study_session, user: user)
      expect do
        delete study_session_path(session_to_delete)
      end.to change(StudySession, :count).by(-1)
    end

    it '一覧ページにリダイレクトされること' do
      delete study_session_path(study_session)
      expect(response).to redirect_to(study_sessions_path)
    end

    it '成功メッセージが表示されること' do
      delete study_session_path(study_session)
      follow_redirect!
      expect(response.body).to include('学習記録が削除されました')
    end
  end

  describe 'PATCH /study_sessions/quick_record' do
    it 'クイック記録が作成されること' do
      expect do
        patch quick_record_study_sessions_path
      end.to change(StudySession, :count).by(1)
    end

    it '25分のセッションが作成されること' do
      patch quick_record_study_sessions_path
      session = StudySession.last
      expect(session.duration).to eq(25)
      expect(session.note).to eq('ポモドーロセッション')
    end

    it 'ダッシュボードにリダイレクトされること' do
      patch quick_record_study_sessions_path
      expect(response).to redirect_to(dashboard_path)
    end

    it '成功メッセージが表示されること' do
      patch quick_record_study_sessions_path
      follow_redirect!
      expect(response.body).to include('25分の学習記録を保存しました')
    end
  end
end
