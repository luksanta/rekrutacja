#!/usr/bin/ruby
require 'json'
require 'optparse'
require 'erb'
require 'fileutils'

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

begin
    # Render main tf from template
    puts "Generating docker compose file"
    template = Template.new(config)

    File.open("compose_new.yaml", 'w') do |f|
        f.write template.render('compose.yaml.erb')
    end

rescue
    puts 'Cannot generate template!'
    raise
end