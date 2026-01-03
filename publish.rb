require 'rss'
require 'open-uri'
require 'mastodon'
require 'dotenv/load'

# --- Configuration ---
MASTODON_BASE_URL = 'https://mastodon.ie'
# You need to generate an Access Token from your Mastodon account settings (Development -> New Application)
ACCESS_TOKEN = ENV['ACCESS_TOKEN']

FEEDS = [
  'https://www.jonathanclarke.ie/feed/fitness.xml',
  'https://www.jonathanclarke.ie/feed.xml'
]

def get_latest_entry_from_feeds(feed_urls)
  candidates = []

  feed_urls.each do |url|
    begin
      # URI.open handles both http and https automatically
      URI.open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        
        # Pluck the latest item (first one in the feed)
        latest_item = feed.items.first
        
        if latest_item
          # Standardize the date (RSS uses pubDate, Atom uses updated)
          date = case feed
                 when RSS::Atom::Feed
                   latest_item.updated.content
                 else
                   latest_item.pubDate
                 end
          candidates << { item: latest_item, date: date }
        end
      end
    rescue StandardError => e
      puts "Error fetching #{url}: #{e.message}"
    end
  end

  # Sort by date descending (newest first) and return the single latest entry
  candidates.max_by { |entry| entry[:date] }
end

# --- Main Execution ---
winner = get_latest_entry_from_feeds(FEEDS)

if winner
  item = winner[:item]
  puts "Latest blog found: #{item.title.content} (#{winner[:date]})"

  # Initialize Mastodon Client
  client = Mastodon::REST::Client.new(
    base_url: MASTODON_BASE_URL,
    bearer_token: ACCESS_TOKEN,
  )

  # Compose the message
  link = item.link.respond_to?(:href) ? item.link.href : item.link
  message = "#{item.title.content}\n\n#{link}"

  puts "Generated message:\n#{message}"
  print "Enter hashtags (e.g., #ruby #programming, leave blank to skip): "
  hashtags = STDIN.gets.chomp.strip

  unless hashtags.empty?
    message << "\n\n#{hashtags}"
  end

  # Publish to Mastodon
  begin
    puts "Final message to be published:\n#{message}"
    client.create_status(message)
    puts "Successfully published to @jonathanclarke on mastodon.ie"
  rescue Mastodon::Error => e
    puts "Failed to publish: #{e.message}"
  end
else
  puts "No blog entries found."
end
