module StatusPage
    record StateSnapshot, is_online

    class State
        getter current

        def initialize(@chan : Channel(Bool))
            @current = StateSnapshot.new(false)

            spawn do
                self.current = process(@chan.receive)
            end
        end

        def snapshot
            @current
        end

        private def current=(new_state)
            puts "updating state"
            @current = new_state
        end

        private def process(is_online)
            StateSnapshot.new is_online
        end
    end
end
