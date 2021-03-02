# frozen_string_literal: true

class Arwen
  # Models the sitemap <url> schema definition according the sitemap.org protocol
  #
  # @see https://www.sitemaps.org/protocol.html#urldef
  class Url
    # @return [string] <loc> schema value
    attr_accessor :url

    # @return [string] <lastmod> schema value
    attr_accessor :lastmod

    # @return [float] <priority> schema value
    attr_accessor :priority

    # @return [string] <changefreq> schema value
    attr_accessor :changefreq

    # The Ox::Element object used to initialize the Url instance
    # @return [Ox::Element]
    attr_reader :raw

    # Create a new SitemapParser::URL
    #
    # @param [Ox::Element] ox_element element in the sitemap tree
    # @see http://www.ohler.com/ox/Ox/Element.html
    def initialize(ox_element)
      @url = ox_element.locate("loc/*").first
      @lastmod = ox_element.locate("lastmod/*").first
      @priority = ox_element.locate("priority/*").first&.to_f
      @changefreq = ox_element.locate("changefreq/*").first
      @raw = ox_element
    end

    # converts the string lastmod value to a `Date` object
    #
    # @return [Date]
    def to_date
      return nil if lastmod.nil?

      Date.parse(lastmod)
    end
  end
end
