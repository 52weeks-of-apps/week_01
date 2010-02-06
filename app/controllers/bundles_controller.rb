class BundlesController < ApplicationController
  def create
    @bundle = Bundle.find_or_create_by_url(params[:bundle][:url])
    @bundle.update_body!
    @bundle.save
    respond_to do |wants|
      wants.html { redirect_to bundle_url(@bundle) }
      wants.xml  { render :xml => @bundle.body, :location => bundle_url(@bundle) }
    end
  end

  def show
    @bundle = Bundle.find(params[:id])
    respond_to do |wants|
      wants.html
      wants.raw { render :text => @bundle.body }
      wants.xml { render :xml => @bundle.body }
    end
  end
end
