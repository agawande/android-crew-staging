class UsageError < RuntimeError; end

class FormulaUnspecifiedError < UsageError
  def to_s
    "this command requires a formula argument"
  end
end

class CommandRequresNoArguments < UsageError
  def to_s
    "this command requires no arguments"
  end
end

class UnknownCommand < UsageError
  def initialize(cmd)
    super "unknown command \'#{cmd}\'"
  end
end

class FormulaUnavailableError < RuntimeError
  attr_reader :name
  attr_accessor :dependent

  def initialize name
    @name = name
  end

  def dependent_s
    "(dependency of #{dependent})" if dependent and dependent != name
  end

  def to_s
    "no available formula for #{name} #{dependent_s}".chomp(' ')
  end
end

class ErrorDuringExecution < RuntimeError
  def initialize(cmd, err)
    msg = err.size > 0 ? "#{cmd}; error output: #{err}" : "#{cmd}"
    super "Failure while executing: #{msg}"
  end
end
