require 'erb'

GCC = "/usr/bin/gcc"
GCCARGS = "-lm -o"
PATTERNDIR = Rails.root + "patterns"
PATTERNTEMPLATE = PATTERNDIR + "c_pattern_template.erb"

class Component < ActiveRecord::Base
  
  has_many :options
  has_many :sketches, :through => :options

  after_validation :build_pattern, if: :is_pattern?

  def build_pattern
    new_pat = global.gsub(/int\s+\w+\s*\(int seq\)/, "int pattern(int seq)")
    new_pat.gsub!(/<%.*:\s*(\d+).*%>/, '\1')
    if (!Dir.exists?(PATTERNDIR))
      Dir.mkdir PATTERNDIR
      false
    end
    pattern_build_dir = PATTERNDIR + name
    c_prog = pattern_build_dir + name
    c_file = pattern_build_dir + "#{name}.c"
    if (!Dir.exists?(pattern_build_dir))
      Dir.mkdir pattern_build_dir
    end
    pattern_template = ERB.new(File.read(PATTERNTEMPLATE))
    c_pattern = pattern_template.result(new_pat.send(:binding))
    File.open c_file, "w" do |file|
      file << c_pattern
    end
    if (system(GCC + " " + c_file.to_s + " " + GCCARGS + " " + c_prog.to_s))
      self.testride = c_prog.to_s
    end
  end

  def is_pattern?
    category.match("^pattern$")
  end

end