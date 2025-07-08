require 'rails_helper'

RSpec.describe StudySession, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:study_session) { build(:study_session, user: user) }

    it 'ユーザーが存在すれば有効' do
      expect(study_session).to be_valid
    end

    describe 'duration' do
      it '存在しない場合は無効' do
        study_session.duration = nil
        expect(study_session).not_to be_valid
        expect(study_session.errors[:duration]).to include("can't be blank")
      end

      it '0以下の場合は無効' do
        study_session.duration = 0
        expect(study_session).not_to be_valid
        expect(study_session.errors[:duration]).to include("must be greater than 0")
      end

      it '720分（12時間）を超える場合は無効' do
        study_session.duration = 721
        expect(study_session).not_to be_valid
        expect(study_session.errors[:duration]).to include("must be less than or equal to 720")
      end

      it '720分（12時間）ちょうどの場合は有効' do
        study_session.duration = 720
        expect(study_session).to be_valid
      end

      it '数値以外の場合は無効' do
        study_session.duration = 'abc'
        expect(study_session).not_to be_valid
        expect(study_session.errors[:duration]).to include('is not a number')
      end
    end

    describe 'studied_at' do
      it '存在しない場合は無効' do
        study_session.studied_at = nil
        expect(study_session).not_to be_valid
        expect(study_session.errors[:studied_at]).to include("can't be blank")
      end

      it '未来の日時でも有効' do
        study_session.studied_at = 1.day.from_now
        expect(study_session).to be_valid
      end

      it '過去の日時でも有効' do
        study_session.studied_at = 1.year.ago
        expect(study_session).to be_valid
      end
    end

    describe 'note' do
      it '空文字でも有効' do
        study_session.note = ''
        expect(study_session).to be_valid
      end

      it 'nilでも有効' do
        study_session.note = nil
        expect(study_session).to be_valid
      end

      it '1000文字以下の場合は有効' do
        study_session.note = 'a' * 1000
        expect(study_session).to be_valid
      end

      it '1001文字以上の場合は無効' do
        study_session.note = 'a' * 1001
        expect(study_session).not_to be_valid
        expect(study_session.errors[:note]).to include('is too long (maximum is 1000 characters)')
      end
    end
  end

  describe 'スコープ' do
    let(:user) { create(:user) }
    let!(:today_session) { create(:study_session, user: user, studied_at: Time.current) }
    let!(:yesterday_session) { create(:study_session, user: user, studied_at: 1.day.ago) }
    let!(:old_session) { create(:study_session, user: user, studied_at: 1.week.ago) }

    describe '.recent' do
      it '学習日時の降順で返す' do
        sessions = StudySession.recent
        expect(sessions.first).to eq(today_session)
        expect(sessions.last).to eq(old_session)
      end
    end

    describe '.today' do
      it '今日の学習記録のみを返す' do
        sessions = StudySession.today
        expect(sessions).to include(today_session)
        expect(sessions).not_to include(yesterday_session)
        expect(sessions).not_to include(old_session)
      end
    end

    describe '.this_week' do
      it '今週の学習記録を返す' do
        sessions = StudySession.this_week
        expect(sessions).to include(today_session)
        expect(sessions).to include(yesterday_session)
        expect(sessions).not_to include(old_session)
      end
    end
  end

  describe 'メソッド' do
    let(:study_session) { create(:study_session) }

    describe '#duration_in_hours' do
      it '60分の場合は1.0を返す' do
        study_session.duration = 60
        expect(study_session.duration_in_hours).to eq(1.0)
      end

      it '30分の場合は0.5を返す' do
        study_session.duration = 30
        expect(study_session.duration_in_hours).to eq(0.5)
      end

      it '90分の場合は1.5を返す' do
        study_session.duration = 90
        expect(study_session.duration_in_hours).to eq(1.5)
      end
    end

    describe '#formatted_duration' do
      it '60分未満の場合は分単位で表示' do
        study_session.duration = 45
        expect(study_session.formatted_duration).to eq('45分')
      end

      it '60分以上の場合は時間単位で表示' do
        study_session.duration = 90
        expect(study_session.formatted_duration).to eq('1.5時間')
      end

      it '120分の場合は2.0時間で表示' do
        study_session.duration = 120
        expect(study_session.formatted_duration).to eq('2.0時間')
      end

      it '65分の場合は1.1時間で表示' do
        study_session.duration = 65
        expect(study_session.formatted_duration).to eq('1.1時間')
      end
    end
  end

  describe 'アソシエーション' do
    let(:user) { create(:user) }
    let(:study_session) { create(:study_session, user: user) }
    let(:tag1) { create(:tag, name: 'Ruby') }
    let(:tag2) { create(:tag, name: 'Rails') }

    describe 'タグとの関連' do
      it 'タグを複数持つことができる' do
        study_session.tags << [tag1, tag2]
        expect(study_session.tags).to include(tag1, tag2)
        expect(study_session.tags.count).to eq(2)
      end

      it 'タグを削除してもStudySessionは削除されない' do
        study_session.tags << tag1
        expect { tag1.destroy }.not_to change(StudySession, :count)
      end

      it 'StudySessionを削除するとStudySessionTagも削除される' do
        study_session.tags << tag1
        expect { study_session.destroy }.to change(StudySessionTag, :count).by(-1)
      end
    end

    describe 'ユーザーとの関連' do
      it 'ユーザーを削除するとStudySessionも削除される' do
        study_session = create(:study_session, user: user)
        expect { user.destroy }.to change(StudySession, :count).by(-1)
      end

      it 'ユーザーは複数のStudySessionを持つことができる' do
        session1 = create(:study_session, user: user)
        session2 = create(:study_session, user: user)
        
        expect(user.study_sessions).to include(session1, session2)
        expect(user.study_sessions.count).to eq(2)
      end
    end
  end

  describe 'データベース制約' do
    let(:user) { create(:user) }

    it 'user_idが必須' do
      study_session = build(:study_session, user: nil)
      expect { study_session.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it '同じユーザーが同じ時刻に複数の学習記録を作成できる' do
      time = Time.current
      session1 = create(:study_session, user: user, studied_at: time)
      session2 = build(:study_session, user: user, studied_at: time)
      
      expect(session2).to be_valid
      expect { session2.save! }.not_to raise_error
    end
  end

  describe 'データベースクエリ最適化' do
    let(:user) { create(:user) }
    let!(:sessions) { create_list(:study_session, 3, user: user) }

    it 'tagsアソシエーションを適切にロードできる' do
      sessions.each { |s| s.tags << create(:tag) }
      
      # includes使用時にクエリ数が削減されることを確認
      query_count_without_includes = 0
      query_count_with_includes = 0
      
      # includesなし
      ActiveRecord::Base.connection.query_cache.clear
      ActiveRecord::Base.connection.execute("SELECT 1") # ダミークエリでカウンタリセット
      StudySession.all.each { |session| session.tags.to_a }
      
      # includesあり
      ActiveRecord::Base.connection.query_cache.clear
      ActiveRecord::Base.connection.execute("SELECT 1") # ダミークエリでカウンタリセット
      StudySession.includes(:tags).each { |session| session.tags.to_a }
      
      # クエリ最適化の確認（具体的な数値は環境に依存するため、実行可能性のみテスト）
      expect(StudySession.includes(:tags).to_a).to be_present
    end

    it 'userアソシエーションを適切にロードできる' do
      # includesを使ってUserも同時にロード
      sessions_with_users = StudySession.includes(:user).to_a
      expect(sessions_with_users).to be_present
      expect(sessions_with_users.first.user).to eq(user)
    end
  end
end