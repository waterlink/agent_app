require "sinatra/base"

require "agent_app/api/entries_view"

module AgentApp
  module Api
    class Server < Sinatra::Base
      def initialize(app, incremental_sync, reset, initial_sync, fetch_entries)
        super(app)

        @incremental_sync, @reset, @initial_sync, @fetch_entries =
          incremental_sync, reset, initial_sync, fetch_entries

        initial_sync.call
      end

      post "/sync/incremental" do
        incremental_sync.call
        "OK"
      end

      post "/sync/reset" do
        reset.call
        initial_sync.call
        "OK"
      end

      get "/entries" do
        content_type "application/json"
        response = fetch_entries.call
        AgentApp::Api::EntriesView.new(response).render
      end

      private

      attr_reader :incremental_sync, :reset, :initial_sync, :fetch_entries
    end
  end
end
