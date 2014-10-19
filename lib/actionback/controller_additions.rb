module ActionBack
  module ControllerAdditions
    extend ActiveSupport::Concern

    module ClassMethods
      def fetch_resource_id(reg_match, route_wrapper)
        reg_match[route_wrapper.parts.index(:id) + 1].to_i
      end

      def fetch_resource(reg_match, route_wrapper)
        resource_id = fetch_resource_id reg_match, route_wrapper
        controller_name.classify.constantize.find resource_id
      end
    end
  end
end
