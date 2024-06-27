module API
  module V1
    module Exceptions
      class BaseError < StandardError
        attr_reader :status, :message

        def initialize message: nil, status: nil
          super
          @status = status || 500
          @message = message || "Something unexpected happened."
        end

        def body
          Rack::Response.new({error: message}.to_json, status)
        end
      end

      class NotFound < BaseError
        def initialize message: nil
          super(
            status: 404,
            message: message || "Oops, we could not find the record you are looking for."
          )
        end
      end

      class Forbidden < BaseError
        def initialize message: nil
          super(
            status: 403,
            message: message || "You are not authorized to access."
          )
        end
      end
    end
  end
end
