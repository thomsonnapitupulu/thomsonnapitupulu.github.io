require 'net/http'
require 'uri'
require 'json'
require 'fileutils'
require 'date'
require 'yaml'

# LinkedIn integration script
# This script fetches posts from your LinkedIn profile and converts them to Jekyll posts

# Configuration
LINKEDIN_ACCESS_TOKEN = ENV['LINKEDIN_ACCESS_TOKEN']
LINKEDIN_USER_ID = ENV['LINKEDIN_USER_ID']
OUTPUT_DIR = File.expand_path('../../_posts', __FILE__)

# Make sure output directory exists
FileUtils.mkdir_p(OUTPUT_DIR)

# LinkedIn API endpoint for user posts
def fetch_linkedin_posts
  return [] if LINKEDIN_ACCESS_TOKEN.nil? || LINKEDIN_USER_ID.nil?
  
  begin
    uri = URI.parse("https://api.linkedin.com/v2/ugcPosts?q=authors&authors=List(#{LINKEDIN_USER_ID})&count=50")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{LINKEDIN_ACCESS_TOKEN}"
    request["X-Restli-Protocol-Version"] = "2.0.0"
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)
    
    if response.code == '200'
      data = JSON.parse(response.body)
      return data['elements'] || []
    else
      puts "Error fetching LinkedIn posts: #{response.code} - #{response.body}"
      return []
    end
  rescue StandardError => e
    puts "Exception fetching LinkedIn posts: #{e.message}"
    return []
  end
end

# Get post details (content, title, etc.)
def get_post_details(post_id)
  begin
    uri = URI.parse("https://api.linkedin.com/v2/ugcPosts/#{post_id}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{LINKEDIN_ACCESS_TOKEN}"
    request["X-Restli-Protocol-Version"] = "2.0.0"
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)
    
    if response.code == '200'
      return JSON.parse(response.body)
    else
      puts "Error fetching post details: #{response.code} - #{response.body}"
      return nil
    end
  rescue StandardError => e
    puts "Exception fetching post details: #{e.message}"
    return nil
  end
end

# Convert LinkedIn post to Jekyll post
def convert_to_jekyll_post(post)
  return nil unless post
  
  # Get the post details
  post_details = get_post_details(post['id'])
  return nil unless post_details
  
  # Extract content
  content = ''
  if post_details['specificContent'] && post_details['specificContent']['com.linkedin.ugc.ShareContent']
    share_content = post_details['specificContent']['com.linkedin.ugc.ShareContent']
    content = share_content['text'] if share_content['text']
  end
  
  # Extract date (created timestamp)
  date = Time.at(post_details['created']['time'] / 1000).to_datetime
  
  # Create title from first line or first few words
  first_line = content.split("\n").first || ''
  title = first_line.length > 50 ? first_line[0, 50] + "..." : first_line
  title = title.empty? ? "LinkedIn Post #{date.strftime('%Y-%m-%d')}" : title
  
  # Create slug for filename
  slug = title.downcase.strip.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
  
  # Create front matter
  front_matter = {
    'layout' => 'post',
    'title' => title,
    'date' => date.strftime('%Y-%m-%d %H:%M:%S %z'),
    'category' => 'writing',
    'source' => 'LinkedIn',
    'source_url' => post_details['permalink'] || '',
    'tags' => ['linkedin']
  }
  
  # Create file content
  file_content = "---\n#{front_matter.to_yaml}---\n\n#{content}"
  
  # Create filename
  filename = "#{date.strftime('%Y-%m-%d')}-#{slug}.md"
  filepath = File.join(OUTPUT_DIR, filename)
  
  # Return the file details
  {
    content: file_content,
    filepath: filepath,
    title: title
  }
end

# Main execution
puts "Fetching LinkedIn posts..."
posts = fetch_linkedin_posts

puts "Found #{posts.count} posts. Converting to Jekyll format..."
posts.each do |post|
  jekyll_post = convert_to_jekyll_post(post)
  
  if jekyll_post
    # Check if file already exists
    if File.exist?(jekyll_post[:filepath])
      puts "Post already exists: #{jekyll_post[:title]}"
    else
      # Write to file
      File.write(jekyll_post[:filepath], jekyll_post[:content])
      puts "Created new post: #{jekyll_post[:title]}"
    end
  end
end

puts "LinkedIn integration complete!"