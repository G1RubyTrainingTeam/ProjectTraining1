class Paying < ApplicationRecord
  belongs_to :e_wallet
  validates :amount, numericality: {greater_than_or_equal_to: 0}
  enum status: %i(not_entered entered)

  def code_expired?
    created_at > 2.minutes.ago
  end
end
