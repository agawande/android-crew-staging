require_relative '../exceptions.rb'


CREW_HELP = <<-EOS
Usage: crew [OPTIONS] COMMAND [parameters]

where

OPTIONS are:
  --backtrace, -b output backtrace with exception message;
                  debug option

COMMAND is one of the following:
  version         output version information
  help            show this help message
  env             show crew's command working environment
  list [libs|utils]
                  list all available formulas for libraries or utilities;
                  whithout an argument list all formulas
  info name ...   show information about the specified formula(s)
  install name[[:version]:crystax_version] ...
                  install the specified formula(s)
  source name[[:version]:crystax_version] ...
                  install source code for the specified formula(s)
  build name[[:version]:crystax_version] ...
                  build the specified formula(s) from the source code
  remove name[:version] ...
                  uninstall the specified formulas
  update          update crew repository information
  upgrade         install most recent versions
  cleanup [-n]    uninstall old versions and clean cache
EOS


module Crew
  def self.help(args)
    if args and args.length > 0
      raise CommandRequresNoArguments
    end
    puts CREW_HELP
  end
end
