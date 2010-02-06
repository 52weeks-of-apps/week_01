class Bundle < ActiveRecord::Base
  before_save :update_body!

  validates_presence_of :url

  def update_body!
    response = Typhoeus::Request.get(url)
    doc = Nokogiri::HTML(response.body)
    replace_scripts!(doc)
    replace_stylesheets!(doc)
    self.body = doc.to_s
  end

  private
    def replace_scripts!(doc)
      doc.xpath("//script[@src!='']").each do |node|
        response = Typhoeus::Request.get(node['src'])
        node.remove_attribute('src')
        node.content = response.body
      end
    end

    def replace_stylesheets!(doc)
      doc.xpath("//link[@rel='stylesheet']").each do |node|
        response = Typhoeus::Request.get(node['href'])
        node.remove_attribute('href')
        node.remove_attribute('rel')
        node.name = 'style'
        node.content = response.body
      end
    end
end
