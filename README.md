# Arwen

Arwen parses sitemaps that adhere to the sitemaps.org protocol.  Inspired by benbalter's [sitemap-parser gem](https://github.com/benbalter/sitemap-parser), arwen automatically detects if recursion is needed by analyzing the presence of `<sitemapindex>`. It also leverages Typheous' parallel request functionality via `Typheous::Hydra` when needed to drastically speed up
fetching large sitemaps.

Documentation: [https://rubydoc.info/gems/arwen](https://rubydoc.info/gems/arwen)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arwen'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install arwen

## Usage

To parse a sitemap, create a new `Arwen` instance, passing it the URL to the sitemap and, optionally, any options that should be passed to `Typheous::Request`.

```ruby
arwen = Arwen.new("https://www.example.org/sitemap.xml")
```
As long as the sitemap implements the sitemaps.org protocol, `arwen` will check if the sitemap should be parsed recursively (i.e. if the sitemap implements `<sitemapindex>`).  The sitemap is not fetched until a method is called that accesses it.

`arwen` uses `Ox` has its XML parser. To access the raw `Ox::Document` sitemap, use the `sitemap` instance method. See the `Ox::Document` [documentation](http://www.ohler.com/ox/Ox/Document.html) for full details.

```ruby
arwen.sitemap # Ox::document
```
The `urls` instance method returns an array of `Arwen::Url` objects.  `Arwen::Url` is a simple object that models the `<url>` schema in the sitemaps.org protocol.

```ruby
arwen.urls # Array<Arwen::Url>
```

To get an array of just the url strings for the whole sitemap, use the `to_a` instance method:

```ruby
arwen.to_a # Array<string>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adamhake/arwen.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

*Yes, the name is a reference to the Half-Elven daughter of Elrond.*