require "rails_helper"

RSpec.describe Wallet, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    subject { FactoryBot.create :wallet }
    it { is_expected.to validate_numericality_of(:account).
      is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_uniqueness_of(:user) }
  end
end
