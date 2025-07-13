require 'rails_helper'

RSpec.describe 'Pomodoro', type: :request do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }

  before do
    sign_in user
  end

  describe 'GET /pomodoro' do
    it '正常にレスポンスが返されること' do
      get pomodoro_path
      expect(response).to have_http_status(:success)
    end

    it 'ポモドーロページが表示されること' do
      get pomodoro_path
      expect(response.body).to include('ポモドーロタイマー')
    end

    context '未認証ユーザーの場合' do
      before do
        sign_out user
      end

      it 'ログインページにリダイレクトされること' do
        get pomodoro_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /pomodoro/save_session' do
    let(:session_params) do
      {
        study_session: {
          duration: 25,
          studied_at: Time.current.iso8601,
          note: 'ポモドーロセッション完了'
        },
        tag_ids: [tag.id]
      }
    end

    context '有効なパラメータの場合' do
      it 'セッションが作成されること' do
        expect do
          post '/pomodoro/save_session', params: session_params
        end.to change(StudySession, :count).by(1)
      end

      it '正しいJSONレスポンスが返されること' do
        post '/pomodoro/save_session', params: session_params
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('ポモドーロセッションを保存しました！')
      end

      it 'タグが正しく関連付けられること' do
        post '/pomodoro/save_session', params: session_params
        session = StudySession.last
        expect(session.tags).to include(tag)
      end

      it 'ユーザーに関連付けられること' do
        post '/pomodoro/save_session', params: session_params
        session = StudySession.last
        expect(session.user).to eq(user)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          study_session: {
            duration: nil,
            studied_at: nil,
            note: 'テスト'
          }
        }
      end

      it 'セッションが作成されないこと' do
        expect do
          post '/pomodoro/save_session', params: invalid_params
        end.not_to change(StudySession, :count)
      end

      it 'エラーのJSONレスポンスが返されること' do
        post '/pomodoro/save_session', params: invalid_params
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to be_present
      end
    end

    context 'when user is not authenticated' do
      before do
        sign_out user
      end

      it 'redirects to login page' do
        post '/pomodoro/save_session', params: session_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
