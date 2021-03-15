#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/error_checker.rb'

run_checks = ErrorChecker.new(ARGV.first)
run_checks.check_white_trailing_spaces
run_checks.check_end_error
run_checks.check_empty_line
run_checks.check_indentation
run_checks.check_tag_error

if run_checks.errors.empty?
  puts 'No offenses'.colorize(:green) + ' detected'
else
  run_checks.errors.uniq.each do |err|
    puts "#{run_checks.check_errors.file_path.colorize(:green)} :
     #{err.colorize(:red)}"
  end
end

if run_checks.check_errors.file_content.empty?
  puts run_checks.check_errors.error_message
end
