# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :owner, presence: true
  validates :color, inclusion: { in: %w(black white red blue calico tabby)}
  validates :sex, inclusion: { in: %w(M F)}
  include ActionView::Helpers::DateHelper
  has_many :cat_rental_requests, dependent: :destroy
  belongs_to :owner, foreign_key: :user_id, class_name: "User"

  def age
    time_ago_in_words(birth_date)
  end
end
