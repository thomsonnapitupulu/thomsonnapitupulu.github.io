require 'net/http'
require 'uri'
require 'json'
require 'fileutils'
require 'date'
require 'yaml'
require 'nokogiri'
require 'rss'

# Medium integration script
# This script fetches your Medium posts and converts them to Jekyll posts

# Configuration
MEDIUM_USERNAME = ENV['MEDIUM_USERNAME'] || 'your-medium-username'
OUTPUT_DIR = File.expand_path('../../_posts', __FILE__)

# Make sure output directory exists
FileUtils.mkdir_p(OUTPUT_DIR)

# Fetch Medium posts via RSS feed
def fetch_medium_posts
  begin
    rss_url = "https://medium.com/feed/@#{MEDIUM_USERNAME}"
    uri = URI.parse(rss_url)
    response = Net::HTTP.get_response(uri)
    
    if response.code == '200'
      feed = RSS::Parser.parse(response.body)
      return feed.items || []
    else
      puts "Error fetching Medium posts: #{response.code}"
      return []
    end
  rescue StandardError => e
    puts "Exception fetching Medium posts: #{e.message}"
    return []
  end
end

# Convert HTML content to Markdown
# Note: This is a simple conversion. For better results, consider using a library like html2md or reverse_markdown
def html_to_markdown(html)
  return '' if html.nil? || html.empty?
  
  doc = Nokogiri::HTML(html)
  
  # Remove Medium-specific elements
  doc.css('figure').each do |figure|
    caption = figure.css('figcaption').text.strip
    img = figure.css('img')
    
    if img.any?
      src = img.first['src']
      alt = img.first['alt'] || caption
      figure.replace("![#{alt}](#{src})\n\n*#{caption}*\n\n")
    else
      figure.remove
    end
  end
  
  # Convert headings
  (1..6).each do |i|
    doc.css("h#{i}").each do |h|
      h.replace("#{'#' * i} #{h.text.strip}\n\n")
    end
  end
  
  # Convert paragraphs
  doc.css('p').each do |p|
    p.replace("#{p.text.strip}\n\n")
  end
  
  # Convert lists
  doc.css('ul').each do |ul|
    items = ul.css('li').map { |li| "* #{li.text.strip}" }.join("\n")
    ul.replace("#{items}\n\n")
  end
  
  doc.css('ol').each do |ol|
    items = []
    ol.css('li').each_with_index do |li, i|
      items << "#{i+1}. #{li.text.strip}"
    end
    ol.replace("#{items.join("\n")}\n\n")
  end
  
  # Convert links
  doc.css('a').each do |a|
    a.replace("[#{a.text}](#{a['href']})")
  end
  
  # Convert code blocks
  doc.css('pre').each do |pre|
    code = pre.text.strip
    pre.replace("```\n#{code}\n```\n\n")
  end
  
  # Convert inline code
  doc.css('code').each do |code|
    code.replace("`#{code.text}`")
  end
  
  # Convert blockquotes
  doc.css('blockquote').each do |quote|
    text = quote.text.strip.gsub(/\n/, "\n> ")
    quote.replace("> #{text}\n\n")
  end
  
  # Return cleaned content
  content = doc.text.strip
  content.gsub!(/\n{3,}/, "\n\n") # Remove excessive newlines
  content
end

# Convert Medium post to Jekyll post
def convert_to_jekyll_post(post)
  return nil unless post
  
  # Extract date
  date = post.date.to_datetime
  
  # Extract title
  title = post.title
  
  # Extract content
  content = html_to_markdown(post.content_encoded)
  
  # Create slug for filename
  slug = title.downcase.strip.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
  
  # Extract tags (categories in RSS)
  tags = []
  if post.categories
    tags = post.categories.map(&:content)
  end
  tags << 'medium'
  
  # Create front matter
  front_matter = {
    'layout' => 'post',
    'title' => title,
    'date' => date.strftime('%Y-%m-%d %H:%M:%S %z'),
    'category' => 'writing',
    'source' => 'Medium',
    'source_url' => post.link,
    'tags' => tags
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
puts "Fetching Medium posts for @#{MEDIUM_USERNAME}..."
posts = fetch_medium_posts

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

puts "Medium integration complete!"