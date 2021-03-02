# frozen_string_literal: true

require "test_helper"

class ArwenMutlipleTest < Minitest::Test
  def test_sitemap_url
    assert_equal "http://www.example.com/", @reader.urls.first.url
  end

  def test_sitemap_lastmod
    assert_equal "2005-01-01", @reader.urls.first.lastmod
  end

  def test_sitemap_url_to_date
    assert_equal Date.parse("2005-01-01"), @reader.urls.first.to_date
  end

  def test_sitemap_priority
    assert_in_delta 0.8, @reader.urls.first.priority
  end

  def test_sitemap_changefreq
    assert_equal "monthly", @reader.urls.first.changefreq
  end

  def test_sitemap_raw
    assert_equal expected_raw_value, @reader.urls.first.raw
  end

  def stub_sitemap_requests
    single_sitemap = IO.read(File.join(File.dirname(__FILE__), "files/sitemap.xml"))
    multi_sitemap = IO.read(File.join(File.dirname(__FILE__), "files/sitemap_index.xml"))
    single_response = Typhoeus::Response.new(code: 200, body: single_sitemap)
    multi_response = Typhoeus::Response.new(code: 200, body: multi_sitemap)
    Typhoeus.stub("https://www.example.com/sitemap.xml").and_return(single_response)
    Typhoeus.stub("https://www.example.com/sitemap_index.xml").and_return(multi_response)
  end

  def setup
    stub_sitemap_requests
    @reader = Arwen.new("https://www.example.com/sitemap_index.xml")
  end

  def teardown
    Typhoeus::Expectation.clear
  end

  def expected_raw_value
    Ox.load(
      <<-XML
        <url>
          <loc>http://www.example.com/</loc>
          <lastmod>2005-01-01</lastmod>
          <changefreq>monthly</changefreq>
          <priority>0.8</priority>
        </url>
      XML
    )
  end
end
