module API
  module V1
    module ExceptionsHandler
      extend ActiveSupport::Concern

      included do
        rescue_from :all do |error|
          case error.class.name
          when "ActiveRecord::RecordNotFound", "V1::Exceptions::NotFound"
            Exceptions::NotFound.new(message: error.message).body
          when " CanCan::AccessDenied"
            Exceptions::Forbidden.new(message: error.message).body
          else
            Exceptions::BaseError.new(message: error.message).body
          end
        end
      end
    end
  end
end
