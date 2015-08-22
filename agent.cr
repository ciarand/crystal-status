require "http/client"

module StatusPage
    class Agent
        def initialize(@url : String, @state_chan : Channel(Bool))
        end

        def check
            @state_chan.send is_online
        end

        private def is_online
            HTTP::Client.get(@url).status_code == 200
        end
    end
end
