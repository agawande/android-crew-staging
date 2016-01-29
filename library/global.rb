require 'pathname'

module Global

  # private

  def self.check_program(prog)
    raise "#{prog} is not executable" unless prog.exist? and prog.executable?
  end

  def self.operating_system
    h = RUBY_PLATFORM.split('-')
    case h[1]
    when /linux/
      'linux'
    when /darwin/
      'darwin'
    when /mingw/
      'windows'
    else
      raise "unsupported host OS: #{h[1]}"
    end
  end

  def self.def_tools_dir(ndkdir, os)
    os64 = "#{os}-x86_64"
    os32 = (os == 'windows') ? "#{os}" : "#{os}-x86"

    dir64 = "#{ndkdir}/prebuilt/#{os64}"
    dir32 = "#{ndkdir}/prebuilt/#{os32}"

    Dir.exists?(dir64) ? dir64 : dir32
  end

  # public

  def self.active_file_path(uname, engine_dir = ENGINE_DIR)
    File.join(engine_dir, uname, ACTIVE_UTIL_FILE)
  end

  def self.active_util_version(uname, engine_dir = ENGINE_DIR)
    File.read(active_file_path(uname, engine_dir)).split("\n")[0]
  end

  def self.active_util_dir(uname, engine_dir = ENGINE_DIR)
    File.join(engine_dir, uname, active_util_version(uname, engine_dir), 'bin')
  end

  def self.raise_env_var_not_set(var)
    raise "#{var} environment varible is not set"
  end

  def self.set_options(opts)
    opts.each do |o|
      case o
      when '--backtrace', '-b'
        @@options[:backtrace] = true
      else
        raise "unknown global option: #{o}"
      end
    end
  end

  def self.backtrace?
    @@options[:backtrace]
  end

  VERSION = "0.3.0"
  OS = operating_system

  DOWNLOAD_BASE = [nil, ''].include?(ENV['CREW_DOWNLOAD_BASE']) ? "https://crew.crystax.net:9876"                      : ENV['CREW_DOWNLOAD_BASE']
  BASE_DIR      = [nil, ''].include?(ENV['CREW_BASE_DIR'])      ? Pathname.new(__FILE__).realpath.dirname.dirname.to_s : Pathname.new(ENV['CREW_BASE_DIR']).realpath.to_s
  NDK_DIR       = [nil, ''].include?(ENV['CREW_NDK_DIR'])       ? Pathname.new(BASE_DIR).realpath.dirname.dirname.to_s : Pathname.new(ENV['CREW_NDK_DIR']).realpath.to_s
  TOOLS_DIR     = def_tools_dir(NDK_DIR, OS)

  # todo:
  PLATFORM_PREBUILTS_DIR = "#{NDK_DIR}/../../platform/prebuilts"

  PLATFORM_NAME = File.basename(TOOLS_DIR)

  HOLD_DIR        = Pathname.new(File.join(NDK_DIR, 'packages')).realpath
  ENGINE_DIR      = Pathname.new(File.join(TOOLS_DIR, 'crew')).realpath
  FORMULA_DIR     = Pathname.new(File.join(BASE_DIR, 'formula')).realpath
  CACHE_DIR       = Pathname.new(File.join(BASE_DIR, 'cache')).realpath
  UTILITIES_DIR   = Pathname.new(File.join(FORMULA_DIR, 'utilities')).realpath
  REPOSITORY_DIR  = Pathname.new(BASE_DIR).realpath

  EXE_EXT  = RUBY_PLATFORM =~ /mingw/ ? '.exe' : ''
  ARCH_EXT = 'tar.xz'

  ACTIVE_UTIL_FILE = 'active_version.txt'

  # private

  @@options = { backtrace: false }

end


def warning(msg)
  STDERR.puts "warning: #{msg}"
end


def error(msg)
  STDERR.puts "error: #{msg}"
end


def exception(exc)
  error(exc)
  STDERR.puts exc.backtrace if Global.backtrace?
end
