require "sinatra"

require "agent_app/memory_store"
require "agent_app/nxt_memory_store"
require "agent_app/cf/source"
require "agent_app/initial_sync"
require "agent_app/incremental_sync"
require "agent_app/reset"
require "agent_app/fetch_entries"
require "agent_app/api/entries_view"

endpoint = ENV.fetch("CF_SOURCE_ENDPOINT")
space_id = ENV.fetch("CF_SOURCE_SPACE_ID")
token = ENV.fetch("CF_SOURCE_TOKEN")

source = AgentApp::Cf::Source.new(endpoint, space_id, token, "all")
store = AgentApp::MemoryStore.new
nxt_store = AgentApp::NxtMemoryStore.new

initial_sync = AgentApp::InitialSync.new(source, store, nxt_store)
incremental_sync = AgentApp::IncrementalSync.new(source, store, nxt_store)
reset = AgentApp::Reset.new(store, nxt_store)
fetch_entries = AgentApp::FetchEntries.new(store)

initial_sync.call

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
