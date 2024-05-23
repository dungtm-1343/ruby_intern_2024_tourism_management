class Tour < ApplicationRecord
  belongs_to :tour_type
  has_many :tour_flights, dependent: :destroy
  has_many :flights, through: :tour_flights
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :tour_name, presence: true,
                        length: {maximum: Settings.tour.max_len_name}
  validates :city, :tour_destination, :description, presence: true
  validates :day_duration, presence: true,
                       numericality: {only_integer: true,
                                      maximum: Settings.tour.max_duration}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: Settings.tour.limit_250_250
  end

  scope :upcoming, ->{order start_date: :asc}

  private
  def end_date_after_start_date
    return unless end_date <= start_date

    errors.add(:end_date, t("end_day_start_date"))
  end
end
