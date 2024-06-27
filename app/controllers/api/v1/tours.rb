module API
  module V1
    class Tours < Grape::API
      prefix "api"
      version "v1", using: :path
      format :json

      resource :tours do
        desc "Return tours"
        params do
          optional :tour_name, type: String, desc: "Name of the tour"
          optional :address, type: String, desc: "Address of the tour"
          optional :statuses, type: Array, desc: "Statuses of the tour"
        end
        get "", root: :tours do
          query = Hash.new.tap do |q|
            q[:tour_name_cont] = params[:tour_name]
            q[:address_cont] = params[:address]
          end
          Tour.ransack(query).result.by_status(params[:statuses])
        end

        desc "Return a tour"
        params do
          requires :id, type: String, desc: "ID of the tour"
        end
        get ":id", root: "tour" do
          Tour.find(params[:id])
        end

        desc "Create a tour"
        params do
          required TOUR_ATTRIBUTES.map(&:to_sym)
        end
        post "", root: :tours do

        end
      end
    end
  end
end
