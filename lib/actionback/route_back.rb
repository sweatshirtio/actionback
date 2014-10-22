module ActionBack
  module RouteBack
    def match_path(path)
      Rails.application.routes.recognize_path path
    end

    def infer_controller(route_params)
      # OPTIMIZE possible to do without instantiating new instance?
      ActionDispatch::Routing::RouteSet::Dispatcher.new.controller route_params
    end

    def id_from_url(url)
      match = match_path url

      infer_controller(match).fetch_resource_id match
    end

    def resource_from_url(url)
      match = match_path url

      infer_controller(match).fetch_resource match
    end
  end
end
