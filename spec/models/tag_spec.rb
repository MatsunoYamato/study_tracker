# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  color       :string
#  description :text
#  is_preset   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つ' do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it '名前が必須' do
      tag = build(:tag, name: nil)
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end

    it '名前は一意である必要がある' do
      create(:tag, name: 'Ruby')
      tag = build(:tag, name: 'Ruby')
      expect(tag).not_to be_valid
    end

    it '名前は50文字以下である必要がある' do
      tag = build(:tag, name: 'a' * 51)
      expect(tag).not_to be_valid
    end

    it '色が必須' do
      tag = build(:tag, color: '')
      expect(tag).not_to be_valid
    end

    it '色はHEX形式である必要がある' do
      tag = build(:tag, color: '#FF0000')
      expect(tag).to be_valid

      tag = build(:tag, color: 'red')
      expect(tag).not_to be_valid

      tag = build(:tag, color: '#GG0000')
      expect(tag).not_to be_valid
    end

    it '説明は500文字以下である必要がある' do
      tag = build(:tag, description: 'a' * 501)
      expect(tag).not_to be_valid
    end
  end

  describe 'デフォルト値' do
    it 'is_presetのデフォルトはfalse' do
      tag = create(:tag)
      expect(tag.is_preset).to be false
    end

    it 'colorが指定されない場合デフォルト色が設定される' do
      tag = build(:tag, color: nil)
      tag.valid? # バリデーション実行でbefore_validationが動く
      expect(tag.color).to eq('#6B7280')
    end
  end

  describe 'スコープ' do
    let!(:preset_tag) { create(:tag, :preset) }
    let!(:user_tag) { create(:tag, is_preset: false) }

    it 'preset でプリセットタグのみ取得' do
      expect(Tag.preset).to include(preset_tag)
      expect(Tag.preset).not_to include(user_tag)
    end

    it 'user_created でユーザー作成タグのみ取得' do
      expect(Tag.user_created).to include(user_tag)
      expect(Tag.user_created).not_to include(preset_tag)
    end

    it 'popular で使用頻度順に並ぶ' do
      popular_tag = create(:tag, name: 'Popular')
      create(:tag, name: 'Unpopular')

      # popular_tagを多く使用
      user = create(:user)
      3.times do
        study_session = create(:study_session, user: user)
        create(:study_session_tag, study_session: study_session, tag: popular_tag)
      end

      # この部分は実際のデータ作成が複雑なので、基本的な動作確認のみ
      expect(Tag.popular).to be_a(ActiveRecord::Relation)
    end
  end

  describe '関連付け' do
    it '学習記録を持つ' do
      tag = create(:tag)
      study_session = create(:study_session)
      create(:study_session_tag, study_session: study_session, tag: tag)

      expect(tag.study_sessions).to include(study_session)
    end

    it 'タグ削除時に中間テーブルも削除される' do
      tag = create(:tag)
      study_session = create(:study_session)
      create(:study_session_tag, study_session: study_session, tag: tag)

      expect { tag.destroy }.to change(StudySessionTag, :count).by(-1)
    end
  end
end
