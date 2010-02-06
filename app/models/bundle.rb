class Bundle < ActiveRecord::Base
  before_save :update_body!

  validates_presence_of :url
  validates_uniqueness_of :url

  def update_body!
    return if cache_until && cache_until > Time.now

    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new(url)
    request.on_complete do |response|
      doc = Nokogiri::HTML(response.body)
      replace_scripts!(hydra, doc)
      replace_stylesheets!(hydra, doc)
      doc
    end
    hydra.queue request
    
    hydra.run
    self.body = request.handled_response.to_s
    self.cache_until = 1.day.from_now
  end

  private
    def absolute_url(url)
      base = URI.parse(self.url)
      uri = URI.parse(url)
      uri.scheme ||= base.scheme
      uri.port ||= base.port unless [80, 443].include?(base.port)
      uri.host ||= base.host
      uri.to_s
    end

    def replace_scripts!(hydra, doc)
      doc.xpath("//script[@src!='']").each do |node|
        request = Typhoeus::Request.new(absolute_url(node['src']))
        request.on_complete do |response|
          node.remove_attribute('src')
          node.content = response.body
        end
        hydra.queue request
      end
    end

    def replace_stylesheets!(hydra, doc)
      doc.xpath("//link[@rel='stylesheet']").each do |node|
        request = Typhoeus::Request.new(absolute_url(node['href']))
        request.on_complete do |response|
          node.remove_attribute('href')
          node.remove_attribute('rel')
          node.name = 'style'
          node.content = response.body
        end
        hydra.queue request
      end
    end
end
