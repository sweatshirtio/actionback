class GroupUsersController < ApplicationController
  # Override fetch_resource method from ControllerAdditions
  def self.fetch_resource(route_params)
    User.where id: route_params[:id], group_id: route_params[:group_id]
  end

  def self.fetch_resource_id(route_params)
    { :id => route_params[:id], :group_id => route_params[:group_id] }
  end
end
