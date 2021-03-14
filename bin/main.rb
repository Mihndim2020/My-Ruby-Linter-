#!/usr/bin/env ruby
require_relative '../error_checker.rb'

run_checks = ErrorChecker.new(ARGV.first)
run_checks.check_white_trailing_spaces
run_checks.check_end_error
run_checks.check_empty_line
run_checks.check_indentation
run_checks.check_tag_error

if run_checks.errors.empty? && run_checks.check_errors.err_msg.empty?
  puts 'No offenses'.colorize(:green) + ' detected'
  else
    run_checks.errors.uniq.each do |err|  
      puts "#{run_check.error_checker.file_path.colorize(:blue)} : #{err.colorize(:red)}"
  end
end

puts run_checks.error_checker.err_msg if run_checks.checker.file_content.empty?