class BundlesController < ApplicationController
  def create
    @bundle = Bundle.find_or_create_by_url(params[:bundle][:url])
    @bundle.update_body!
    @bundle.save
    redirect_to bundle_url(@bundle)
  end

  def show
    @bundle = Bundle.find(params[:id])
  end
end
