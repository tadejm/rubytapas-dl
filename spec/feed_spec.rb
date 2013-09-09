require "rss"
require "rexml/document"

class Feed
  def initialize(input)
    @feed = RSS::Parser.parse(input)
  end

  def items
    Enumerator.new do |y|
      @feed.items.each do |item|
        y << [item.title, item.description]
      end
    end
  end
end

class Episode
  SELECTOR = "//a[contains(@href, 'subscriber/download?file_id')]"
  def initialize(input)
    @doc = REXML::Document.new(input)
  end

  def links
    Enumerator.new do |y|
      REXML::XPath.each(@doc, SELECTOR) do |a|
        y << [a.attribute("href").to_s, a.text]
      end
    end
  end
end

describe Episode do
  it "returns its name" do
  end

  it "returns its description" do
    dscs = Feed.new(feed_source).items.to_a.map &:last
    dscs.each do |d|
      e = Episode.new(d)
      p e.links.to_a
      exit
    end
  end
end

def feed_source
  File.read(File.expand_path("../feed.rss", __FILE__))
end

describe Feed do
  it "returns feed items" do
    require 'pp'
    names = Feed.new(feed_source).items.to_a.map &:first
    names.map do |name|
      sane = name.gsub /[^-_.() [:alnum:]+]/, ""
      if name != sane
        # pp name
        # pp sane
        # p "---"
      end
    end
  end
end
