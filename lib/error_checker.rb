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
      log_error_message("Lint/Syntax: Unexpected 'end'")
    end   
  end 

  def check_empty_line
    @check_errors.file_content.each_with_index do |str, idx|
      check_class_empty_line(str, idx)
      check_def_empty_line(str, idx)
      check_end_empty_line(str, idx)
      check_empty_line_do_block(str, idx) 
  end

  def check_indentation
    message = 'Use two spaces for indentation'
    current_value = 0
    indented_value = 0

    @check_errors.file_content.each_with_index do |str, idx|
      strip_line = str.strip.split(' ')
      expected_value = current_value + 2
      reserved_words = w%[class def if elsif until module unless begin case]

      next unless !str.strip.empty? || !strip_line.first.eql?('#')

      indented_value += 1 if reserved_words.include?(strip_line.first) || strip_line.include?('do') 
      indented_value -= 1 if str.strip == 'end' 

      next if str.strip.empty?

      indentation_error(str, idx, exp_val, msg)
      current_value = indented_value
    end
  end

  def check_end_error
    keywords_count = 0
    end_counts = 0
    @check_errors.file_content.each_with_index do |str, idx|
      if @keywords.include?(str_val.split(' ').first) || str_val.split(' ').include?('do')
        keywords_count += 1
      end
      if str_val.strip == 'end'
        end_counts += 1
      end

      log_error_message("Lint/Syntax: Missing 'end'") if status.eql?(1)
      log_error_message("Lint/Syntax: Unexpected 'end'") if status.eql?(-1)
    end
  end 
  
  def check_tag_error
    tag_errors(/\{/, /\}/, '{', '}', 'Curly Bracket')
    tag_errors(/\[/, /\]/, '[', ']', 'Square Bracket')
    tag_errors(/\(/, /\)/, '(', ')', 'Parenthesis')
  end
end 