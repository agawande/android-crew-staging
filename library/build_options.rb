require_relative 'utils.rb'


class Build_options

  attr_accessor :abis, :num_jobs
  attr_writer :build_only, :no_clean

  def initialize(opts)
    @abis = nil
    @build_only = false
    @no_clean = false
    @num_jobs = Utils.processor_count * 2

    opts.each do |opt|
      case opt
      when /^--abis=/
        @abis = opt.split('=')[1].split(',')
      when '--build-only'
        @build_only = true
      when '--no-clean'
        @no_clean = true
      when /^--num-jobs=/
        @num_jobs = opt.split('=')[1]
      else
        raise "unknow option: #{opt}"
      end
    end
  end

  def build_only?
    @build_only
  end

  def no_clean?
    @no_clean
  end
end