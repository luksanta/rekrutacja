#!/usr/bin/ruby
require 'json'
require 'optparse'
require 'erb'
require 'fileutils'
require 'logger'

class Template
  def initialize config
    @config = config
  end

  def render path
    content = File.read(File.expand_path(path))
    t = ERB.new(content, nil, '-')
    t.result(binding)
  end
end

config = { 
    :container_name => "rekrutacja_2", 
    :image_name => "rekrutacja", 
    :image_tag => "latest",
    :ports => "8080:80"
}

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: create_compose.rb [options]"

  opts.on("-c", "--container-name", "Container Name") do |v|
    options[:container_name] = v
  end

  opts.on("-t", "--image-tag", "Image tag") do |v|
    options[:image_tag] = v
  end

  opts.on("-p", "--ports", "Exposed ports") do |v|
    options[:ports] = v
  end

  opts.on("-i", "--image-name", "Image Name") do |v|
    options[:image_name] = v
  end
end.parse!

logger = Logger.new(STDOUT)

begin
    # Render main tf from template
    logger.debug "Generating docker compose file"
    template = Template.new(options)

    File.open("compose.yaml", 'w') do |f|
        f.write template.render('compose.yaml.erb')
    end

rescue
    logger.fatal 'Cannot generate template!'
    raise
end