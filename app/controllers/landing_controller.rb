class LandingController < ApplicationController
  def root
    @bundle = Bundle.new(params[:bundle])
  end
end
