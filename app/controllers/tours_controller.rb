class ToursController < ApplicationController
  def index
    params = search_params ? search_params[:tour_name] : nil
    @pagy, @tours = pagy(Tour.all.search_tour(params).upcoming,
                         items: Settings.tour.items_per_page)
  end

  private

  def search_params
    return nil unless params[:tour]

    params.require[:tour].permit :tour_name
  end

  def value_search search_hash, key
    search_hash&.dig(key)
  end
end
