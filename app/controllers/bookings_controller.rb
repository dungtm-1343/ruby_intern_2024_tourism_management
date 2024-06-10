class BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!
  before_action :set_tour, only: %i(new create)
  before_action :load_booking, only: :show

  def new
    @booking = current_user.bookings.build tour_id: @tour.id

    flights_scope = Flight.departing_on(@tour.start_date)
                          .arriving_at(@tour.city)
                          .order_by_brand

    if params[:airline_brand].present?
      flights_scope = flights_scope.airline_brand(params[:airline_brand])
    end

    @pagy, @available_flights = pagy(flights_scope, items: Settings.digit_4)
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      flash[:success] = t "flash.booking.create_success"
      redirect_to tours_path
    else
      flash[:danger] = t "flash.booking.create_failed"
      render :new
    end
  end

  def show; end

  private

  def load_booking
    @booking = Booking.includes(:tour).find_by(id: params[:id])
    return if @booking && @booking.user == current_user

    flash[:warning] = t "flash.booking.not_found"
    redirect_to user_path current_user
  end

  def set_tour
    @tour = Tour.find_by(id: params[:tour_id])
    return if @tour.present?

    flash[:danger] = t "flash.tour.find_tour_failed"
    redirect_to tours_path
  end

  def booking_params
    params.require(:booking).permit Booking::BOOKING_ATTRIBUTES
  end
end
