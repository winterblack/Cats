class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: %w(black white red blue calico tabby)}
  validates :sex, inclusion: { in: %w(M F)}
  include ActionView::Helpers::DateHelper
  has_many :cat_rental_requests, dependent: :destroy

  def age
    time_ago_in_words(birth_date)
  end
end
