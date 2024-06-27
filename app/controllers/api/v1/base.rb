module API
  module V1
    class Base < Grape::API
      include ExceptionsHandler
      mount V1::Tours
    end
  end
end
