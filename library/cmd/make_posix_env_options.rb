require_relative '../arch.rb'
require_relative '../command_options.rb'


class MakePosixEnvOptions

  extend CommandOptions

  attr_accessor :top_dir, :abi, :with_packages

  def initialize(opts)
    @make_tarball = true
    @check_shasum = true
    @with_packages = []

    package_names = []
    opts.each do |opt|
      case opt
      when /^--top-dir=/
        @top_dir = opt.split('=')[1]
      when /^--abi=/
        @abi = opt.split('=')[1]
        raise "unknown abi '#{@abi}'" unless Arch::ABI_LIST.include? @abi
      when '--no-tarball'
        @make_tarball = false
      when '--no-check-shasum'
        @check_shasum = false
      when /^--with-packages=/
        package_names = opt.split('=')[1].split(',')
      else
        raise "unknow option: #{opt}"
      end
    end

    raise "--top-dir option is requried" unless @top_dir
    raise "--abi option is requried"     unless @abi

    # todo: allow version to be given along with package name like in make-standalone-toolchain command
    #       also allow packages from the --with-package option to overwrite default packages versions
    @with_packages = package_names
  end

  def make_tarball?
    @make_tarball
  end

  def check_shasum?
    @check_shasum
  end
end
