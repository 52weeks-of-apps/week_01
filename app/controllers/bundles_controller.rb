class BundlesController < ApplicationController
  def create
    @bundle = Bundle.create!(params[:bundle])
    redirect_to bundle_url(@bundle)
  end

  def show
    @bundle = Bundle.find(params[:id])
  end
end
