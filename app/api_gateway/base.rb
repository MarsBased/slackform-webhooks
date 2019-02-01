module ApiGateway
  class Base
    include HTTParty

    def make_post(*args)
      handle_response(self.class.post(*args))
    end

    private

    def handle_response(response)
      if response.success?
        response.parsed_response
      else
        raise response.response
      end
    end

  end
end
