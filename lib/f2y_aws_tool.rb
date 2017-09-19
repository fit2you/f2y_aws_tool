require 'aws-sdk'
require 'yaml'
require 'log4r'
require "active_support/hash_with_indifferent_access"

require_relative "./f2y_aws_tool/version"
require_relative "./f2y_aws_tool/deploy"

module F2yAwsTool

  class MissingAwsCredentials < StandardError; end

  extend self

  include Log4r

  def log(level)
    @log = Logger.new 'F2Y-AWS-TOOL'
    @log.level = Log4r.const_get(level)
    @log.add(Log4r::StdoutOutputter.new("F2Y-AWS-TOOL-STDOUT", {formatter: log_format}))
    @log
  end

  def log_format
    @log_format ||= Log4r::PatternFormatter.new(:pattern => "F2Y-AWS-TOOL::%l %d :: %m", :date_pattern => "%a %d %b %H:%M %p %Y")
  end

end
