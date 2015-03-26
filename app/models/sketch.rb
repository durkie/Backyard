require 'json'
require 'erb'
require 'securerandom'
require 'fileutils'
require 'digest'
require 'open3'

SKETCHDIR = Rails.root + "sketches"
CATEGORIES = ["general", "pattern"]

INO = "/usr/local/bin/ino"
TARGET = "LilyPadUSB"
TARGETNOHID = "LilyPadUSBnoHID"
AVROBJCOPY = "/usr/bin/avr-objcopy"
AVROBJCOPYOPTS = "-I ihex -O binary"

class Sketch < ActiveRecord::Base

  has_many :options
  has_many :toys
  has_many :components, :through => :options
  has_many :users, :through => :toys

  ## Fetch all components, join them together, process ERB substitutions
  ## Returns compilable Arduino code
  def create_sketch
    header = Component.find_by_name('header')
    # self.options.new({component_id: header.id,
    #   component_name: "#{header.category}/#{header.name}"})
    component_list = Array.new
    component_list.push(Component.find_by_name("header"))
    toy = read_config
    component_list.push(parse_config(toy, "general"))
    footer = Component.find_by_name('footer')
    # self.options.new({component_id: footer.id,
    #  component_name: "#{footer.category}/#{footer.name}"})
    component_list.push(Component.find_by_name("footer"))
    component_list.flatten!
    global = component_list.map { |g| g.global }.join("")
    setup = component_list.map { |g| g.setup }.join("")
    loop = component_list.map { |g| g.loop }.join("")
    sketch_template = ERB.new([global, setup, loop].join("\n"))
    @sketch = sketch_template.result(toy.send(:binding))
    sketchfile = get_src_dir + "sketch.ino"
    File.open sketchfile, "w" do |file|
        file << @sketch
    end
    configfile = get_src_dir + "config.json"
    File.open configfile, "w" do |file|
      file << self.config
    end
  end

  def get_src_dir
    get_build_dir + "src"
  end

  def get_build_dir
    if (!Dir.exists?(SKETCHDIR))
      Dir.mkdir SKETCHDIR
    end
    if (!self.build_dir)
      token = get_token
      dir = SKETCHDIR + token
      while (Dir.exists?(dir))
        token = get_token
        dir = SKETCHDIR + token
      end
      Dir.mkdir dir
      src = dir + "src"
      Dir.mkdir src
      self.build_dir = dir
      self.save!
    end
    Pathname.new(self.build_dir)
  end

  def clean_build_dir
    origdir = Dir.getwd
    Dir.chdir(get_build_dir)
    Open3.capture2(INO, "clean")
    Dir.chdir(origdir)
  end

  def build_sketch
    origdir = Dir.getwd
    Dir.chdir(get_build_dir)
    clean_build_dir
    objdir = get_build_dir + ".build" + TARGETNOHID
    if (system(INO + " build -m " + TARGETNOHID))
      @hex = objdir + "firmware.hex"
      @bin = objdir + "firmware.bin"
      if (system(AVROBJCOPY + " " + AVROBJCOPYOPTS + " #{@hex} #{@bin}"))
        self.sha256 = Digest::SHA256.file @bin
        self.size = File.size? @bin
        if (!Sketch.where("size = ? AND sha256 = ?", self.size, self.sha256))
          self.save!
        end
      else
        puts "avr-objcopy failed: #{$?}"
      end
    else
      puts "Build failed: #{$?}"
    end
    Dir.chdir(origdir)
  end

  def read_config
    config_options = JSON.parse(self.config)
    config_options['toy']
  end

# Traverse the configuration hash and fetch the global, local and setup segments
# for each component. Will recurse in to directions named in TRAVERSE
  def parse_config(item, category)
    list = Array.new
    item.keys.each do |o|
      next if (!item[o])
      if (CATEGORIES.index(o))
        list.push(parse_config(item[o], o))
      else
        if (item[o].class != FalseClass)
          component = o
        elsif (item[o].class == Array)
          component = item[o]
        end
        list.push(Component.where({name: component, category: category}))
        puts component
      end
    end
    list
  end

  def get_token
    date = Time.now.strftime("%Y-%m-%d")
    token = "#{date}-" + SecureRandom.hex(6)
    token
  end

  def find_by_hex(hex)
  end

end
