module ActionBack
  module ControllerAdditions
    extend ActiveSupport::Concern

    module ClassMethods
      def fetch_resource_id(route_params)
        route_params[:id]
      end

      def fetch_resource(route_params)
        resource_id = fetch_resource_id route_params
        controller_name.classify.constantize.find resource_id
      end
    end
  end
end
