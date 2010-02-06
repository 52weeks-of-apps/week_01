module Typhoeus
  class Request
    def self.get(url)
      return Response.new
    end
  end

  class Response
    attr_reader :body

    @response_body = "some body"

    def self.response_body
      @response_body
    end

    def self.response_body=(str)
      @response_body = str
    end

    def initialize
      @body = self.class.response_body
    end
  end
end
