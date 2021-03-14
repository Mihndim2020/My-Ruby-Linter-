require 'colorize'
require 'strscan'
require_relative 'file_reader.rb'
require 'error_types.rb'

class ErrorChecker
  include ErrorTypes
  attr_reader :check_errors, :errors

  def initialize(file_path)
    @check_errors = FileReader.new(file_path)
    @errors = []
    @keywords = %w[begin case class def do if module unless]
  end
  
  def check_white_trailing_spaces
    @check_errors.file_content.each_with_index do |str, idx|
      if !str.strip.empty?
        @errors << "Line: #{idx+1}:#{str.size - 1}: Error: Trailing whitespace detected."
      end
    end
  end

  def check_end_error
    number_of_keywords = 0
    number_of_ends = 0
    @check_errors.file_content.each_with_index do |str, idx|
      if @keywords.include?(str.split(' ').first) || str.split(' ').include?('do')
        number_of_keywords += 1
      end  
      if str.strip == 'end'
        number_of_ends += 1
      end 
    end 
    if (number_of_keywords >  number_of_ends)
      log_error("Lint/Syntax: Missing 'end'")
    end
    if (number_of_keywords <  number_of_ends)
      log_error("Lint/Syntax: Unexpected 'end'")
    end   
  end 

  def check_empty_line
    @check_errors.file_content.each_with_index do |str, idx|
      check_class_empty_line(str, idx)
      check_def_empty_line(str, idx)
      check_end_empty_line(str, idx)
      check_empty_line_do_block(str, idx) 
  end
end 