module Typhoeus
  class Hydra
    def initialize
      @requests = []
    end

    def queue(request)
      @requests << request
    end

    def run
      until @requests.empty?
        req = @requests.shift
        req.run
      end
    end
  end

  class Request
    attr_reader :handled_response

    def self.get(url)
      return Response.new(url)
    end

    def initialize(url)
      @url = url
    end

    def on_complete(&block)
      @on_complete = block
    end

    def run
      @handled_response = @on_complete.call(Response.new(@url))
    end
  end

  class Response
    attr_reader :body

    @response_bodies = Hash.new("<html></html>")

    def self.response_bodies
      @response_bodies
    end

    def initialize(url)
      @body = self.class.response_bodies[url]
    end
  end
end
