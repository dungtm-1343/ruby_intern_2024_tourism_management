class Admin::ToursController < Admin::AdminController
  before_action :set_tour, only: %i(show edit update)
  def index
    @pagy, @tours = pagy(Tour.upcoming,
                         items: Settings.tour.items_per_page)
  end

  def show; end

  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new(tour_params)
    @tour.image.attach params.dig(:tour, :image)
    if @tour.save
      redirect_to admin_tours_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tour.update tour_params
      flash[:success] = t "flash.tour.update_success"
      redirect_to admin_tours_path, status: :see_other
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_tour
    @tour = Tour.find(params[:id])
    return if @tour

    redirect_to admin_tours_path, status: :see_other
    flash[:danger] = t "flash.tour.not_exist"
  end

  def tour_params
    params.require(:tour).permit Tour::TOUR_ATTRIBUTES
  end
end
