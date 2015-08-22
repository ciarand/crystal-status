require "http"

module StatusPage
    class WebApp
        def initialize(state)
            @state = state
        end

        def handle(request)
            HTTP::Response.ok "text/plain", create_body @state.snapshot
        end

        private def create_body(snapshot)
            str = "Hello world! The time is #{Time.now}. "

            str += if snapshot.is_online
                       "The site is online!"
                   else
                       "The site is offline :("
                   end

            str
        end
    end
end
