require_relative '../command_options.rb'


class InfoOptions

  extend CommandOptions

  attr_reader :show_info

  def initialize(opts)
    @show_info = :all

    opts.each do |opt|
      case opt
      when '--versions-only'
        @show_info = :versions
      when '--path-only'
        @show_info = :path
      else
        raise "unknow option: #{opt}"
      end
    end
  end
end
