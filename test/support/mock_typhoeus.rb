module Typhoeus
  class Request
    def self.get(url)
      return Response.new(url)
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
