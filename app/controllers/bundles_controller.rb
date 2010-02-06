class BundlesController < ApplicationController
  def create
    render :text => "You sent me #{params[:bundle][:url]}. Thanks!"
  end
end
