class Bundle < ActiveRecord::Base
  before_save :update_body!

  validates_presence_of :url

  def update_body!
    response = Typhoeus::Request.get(url)
    self.body = response.body
  end
end
