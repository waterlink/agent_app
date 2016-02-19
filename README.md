# AgentApp

Cache application for agents, that will be mostly offline.

## Architecture

![Architecture](http://g.gravizo.com/g?
  digraph G {
    "DOMAIN[Interactors]" -> {DataStores DataSources Requests Responses}
    InputControllers -> Requests
    Presenters -> Responses
    {MemoryStore FileStore} -> DataStores
    {MemorySource APISource} -> DataSources
  }
)

## Installation

    $ gem install agent_app

## Usage

    # TODO: integrate with command line arguments
    $ agent_app --endpoint=<api endpoint> --space=<space name> --token=<access token>
    
    # Meanwhile, use environment variables:
    $ export CF_SOURCE_ENDPOINT=http://example.org
    $ export CF_SOURCE_SPACE_ID=my_space_id
    $ export CF_SOURCE_TOKEN=oauth_token
    $ agent_app

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To run specs use: `bundle exec rspec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/waterlink/agent_app. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
