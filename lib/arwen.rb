# frozen_string_literal: true

require "arwen/version"
require "arwen/url"
require "ox"
require "typhoeus"

# Parses a sitemap url and provides all links provided by the sitemap or sitemap_index.
# It uses Typheous for network requests and making concurrent requests when parsing a sitemap_index.
# Ox is the XML parser used to parse the sitemap. Sitemaps are assumed to follow the sitemaps.org protocol.
#
# @see https://github.com/typhoeus/typhoeus
# @see https://github.com/ohler55/ox
# @see https://www.sitemaps.org/protocol.html
class Arwen
  # Create a new Arwen instance
  #
  # @param [string] url the full URL to the sitemap or sitemap_index XML file
  # @param [hash] opts options passed to Typheous::Request instances.
  # @option opts [integer] :max_concurrency maximum concurrent requests passed to Typheous::Hydra
  # @see https://rubydoc.info/github/typhoeus/typhoeus/Typhoeus/Request
  def initialize(url, opts = {})
    @url = url
    max_concurrency = opts.delete(:max_concurrency) { 200 }
    @opts = { followlocation: true }.merge(opts)
    @hydra = Typhoeus::Hydra.new(max_concurrency: max_concurrency)
  end

  # fetches and returns all urls for the sitemap with corresponding <url> sitemap schema metadata
  #
  # @return [Array<SitemapParser::Url>]
  def urls
    @urls ||= all_urls(sitemap)
  end

  # returns an array of url strings for all URls in the sitemap
  #
  # @return [Array<String>]
  def to_a
    urls.map(&:url)
  end

  # parses the sitemap url to an Ox::Document instance
  #
  # @return [Ox::Document]
  # @see http://www.ohler.com/ox/Ox/Document.html
  def sitemap
    @sitemap ||= raw_sitemap
  end

  private

  def all_urls(sitemap)
    return parse_multiple_sitemaps(sitemap) if sitemap.root.respond_to?(:sitemap)

    parse_single_sitemap(sitemap)
  end

  def parse_multiple_sitemaps(sitemap)
    raise "invalid sitemap format" unless sitemap&.root&.value == "sitemapindex"

    urls = sitemap.root.locate("sitemap/loc/*")
    site_urls = []

    requests = fetch_sitemaps(urls)
    requests.each do |req|
      sitemap = Ox.load(req.response.body)
      site_urls += parse_single_sitemap(sitemap)
    end

    site_urls
  end

  def fetch_sitemaps(urls)
    requests = urls.map do |url|
      req = Typhoeus::Request.new(url, @opts)
      @hydra.queue(req)
      req
    end
    @hydra.run

    requests
  end

  def parse_single_sitemap(sitemap)
    raise "invalid sitemap format" unless sitemap&.root&.value == "urlset"

    sitemap.root.nodes.map { |node| Url.new(node) }
  end

  def raw_sitemap
    response = Typhoeus.get(@url, @opts)
    raise "invalid sitemap url for #{@url}" unless response.success?

    Ox.load(response.body)
  end
end
