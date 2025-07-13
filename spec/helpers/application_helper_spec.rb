require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#format_duration_minutes' do
    it 'nilの場合は0分を返す' do
      expect(helper.format_duration_minutes(nil)).to eq('0分')
    end

    it '0の場合は0分を返す' do
      expect(helper.format_duration_minutes(0)).to eq('0分')
    end

    it '60分未満の場合は分単位で表示' do
      expect(helper.format_duration_minutes(30)).to eq('30分')
      expect(helper.format_duration_minutes(59)).to eq('59分')
    end

    it '60分以上の場合は時間単位で表示' do
      expect(helper.format_duration_minutes(60)).to eq('1.0時間')
      expect(helper.format_duration_minutes(90)).to eq('1.5時間')
      expect(helper.format_duration_minutes(120)).to eq('2.0時間')
    end

    it '小数点以下の丸め処理が正しく動作する' do
      expect(helper.format_duration_minutes(65)).to eq('1.1時間')
      expect(helper.format_duration_minutes(66)).to eq('1.1時間')
      expect(helper.format_duration_minutes(67)).to eq('1.1時間')
    end

    it '大きな値でも正しく表示される' do
      expect(helper.format_duration_minutes(1440)).to eq('24.0時間') # 1日
      expect(helper.format_duration_minutes(10_080)).to eq('168.0時間') # 1週間
    end
  end
end
