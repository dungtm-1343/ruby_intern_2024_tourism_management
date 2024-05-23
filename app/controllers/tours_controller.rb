class ToursController < ApplicationController
  def index
    @pagy, @tours = pagy(Tour.all.upcoming,
                         items: Settings.tour.items_per_page)
  end
end
