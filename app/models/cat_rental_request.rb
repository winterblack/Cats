# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ActiveRecord::Base
  validates :status, inclusion: {in: %w(PENDING APPROVED DENIED)}
  validates :start_date, :end_date, :status, :user_id, presence: true
  validate :does_not_overlap_approved_request
  belongs_to :cat
  belongs_to :user

  def approve!
    transaction do
      self.status = "APPROVED"
      self.save!
      overlapping_requests("PENDING").update_all(status: "DENIED")
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def overlapping_requests(status)
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: self.cat_id)
      .where("status = '#{status}'")
      .where(<<-SQL, start_date: start_date, end_date: end_date)
        NOT((start_date > :end_date) OR (end_date < :start_date))
      SQL
  end

  def does_not_overlap_approved_request
    return if status == "DENIED"
    unless overlapping_requests("APPROVED").empty?
      errors[:request] << "overlaps approved request"
    end
  end
end
