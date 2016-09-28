class Sale < ActiveRecord::Base

  belongs_to :customer
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :date, presence: true
  validates :status, presence: true
  validates :description, presence: false

  validate :date_of_a_sale_cannot_be_in_the_past

  private
    def date_of_a_sale_cannot_be_in_the_past
      if date.present? && date < Date.today
        errors.add(:date, "can't be in the past")
      end
    end
end
