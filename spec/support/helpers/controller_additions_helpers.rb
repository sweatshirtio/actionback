module Helpers
  module ControllerAdditionsHelpers
    def route_match(route_wrap, str)
      Regexp.new(route_wrap.json_regexp).match(str)
    end
  end
end
