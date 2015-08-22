#!/usr/bin/env crystal

require "http/server"
require "concurrent/scheduler"
require "option_parser"

require "./web_app"
require "./agent"
require "./state"

module StatusPage
    record Config, port

    module CLI
        def self.parse_options(args)
            config :: Config

            OptionParser.parse(args) do |opts|
                opts.on("-h", "--help", "Shows this message") do
                    puts opts
                    exit
                end

                opts.on("-p PORT", "--port PORT", "The port to listen on") do |port|
                    config = Config.new(port.to_i)
                end
            end

            return config != nil ? config : Config.new(8080)
        end

        def self.main(args : Array(String))
            conf = parse_options args

            state_chan = Channel(Bool).new
            state = StatusPage::State.new(state_chan)

            app = StatusPage::WebApp.new state
            server = HTTP::Server.new(conf.port) do |request|
                app.handle request
            end

            agent = StatusPage::Agent.new "https://www.google.com", state_chan
            spawn do
                loop do
                    puts "calling agent loop"
                    agent.check
                    puts "sleeping"
                    sleep 5
                    puts "done sleeping"
                end
            end

            puts "Listening on http://0.0.0.0:#{conf.port}"
            server.listen
        end
    end
end

StatusPage::CLI.main ARGV
