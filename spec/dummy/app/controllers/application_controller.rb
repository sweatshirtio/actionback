class ApplicationController < ActionController::Base
  include ActionBack::ControllerAdditions
  protect_from_forgery with: :exception
end
