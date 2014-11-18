class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  include ActionBack::ControllerAdditions

  private

  def authenticate_user!
    raise 'This is a protected resource!'
  end
end
