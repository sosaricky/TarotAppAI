require "rails_helper"

RSpec.describe User do
  describe "#daily_readings_count" do
    it "counts the readings created today" do
      user = create(:user)
      create_list(:reading, 2, user: user)

      expect(user.daily_readings_count).to eq(2)
    end
  end

  describe "#reached_daily_reading_limit?" do
    it "returns false when under the limit" do
      allow(User).to receive(:daily_reading_limit).and_return(3)
      user = create(:user)
      create_list(:reading, 2, user: user)

      expect(user.reached_daily_reading_limit?).to be(false)
    end

    it "returns true when at the limit" do
      allow(User).to receive(:daily_reading_limit).and_return(3)
      user = create(:user)
      create_list(:reading, 3, user: user)

      expect(user.reached_daily_reading_limit?).to be(true)
    end
  end
end
