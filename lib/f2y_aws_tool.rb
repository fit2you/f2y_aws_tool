require 'aws-sdk'
require 'yaml'
require 'log4r'

require "f2y_aws_tool/version"
require "f2y_aws_tool/deploy"

module F2yAwsTool
  extend self

  include Log4r

  def log(level)
    @log = Logger.new 'F2Y-AWS-TOOL'
    @log.level = Log4r.const_get(level)
    @log.add(Log4r::StdoutOutputter.new("F2Y-AWS-TOOL-STDOUT", {formatter: log_format}))
    @log
  end

  def log_format
    @log_format ||= Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m", :date_pattern => "%a %d %b %H:%M %p %Y")
  end

  # Your code goes here...
end
