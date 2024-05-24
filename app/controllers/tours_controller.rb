class ToursController < ApplicationController
  before_action :search_upcoming, :filter_tours, only: :index

  def index
    @pagy, @tours = pagy(@tours, items: Settings.tour.items_per_page)
  end

  private

  def search_upcoming
    @tours = Tour.upcoming
  end

  def search_by_attr field
    if Tour::RANGE_ATTRIBUTES.include? field
      method_min = "by_min_#{field}"
      method_max = "by_max_#{field}"
      min_value = params["min_#{field}"]
      max_value = params["max_#{field}"]
      @tours = @tours.public_send method_min, min_value if min_value.present?
      @tours = @tours.public_send method_max, max_value if max_value.present?
    else
      param = params[field]
      method = "by_#{field}"
      @tours = @tours.public_send method, param if param.present?
    end
  end

  def search_with_and
    Tour::SEARCH_ATTRIBUTES.each{|field| search_by_attr field}
  end

  def search_with_or
    tours = []
    Tour::SEARCH_ATTRIBUTES.each do |field|
      @tours = Tour.upcoming
      search_by_attr field
      tours += @tours
    end
    @tours = Tour.where(id: tours.map(&:id)).distinct
  end

  def filter_tours
    if params[:search_type]
      search_with_or
    else
      search_with_and
    end
  end
end
