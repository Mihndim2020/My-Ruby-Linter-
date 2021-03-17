# rubocop: disable Metrics/CyclomaticComplexity

require 'colorize'
require 'strscan'
require_relative 'file_reader'
require_relative 'error_types'

class ErrorChecker < ErrorTypes
  super
  attr_reader :check_errors, :errors

  def initialize(file_path)
    @check_errors = FileReader.new(file_path)
    @errors = []
    @keywords = %w[begin case class def do if module unless]
  end

  def check_white_trailing_spaces
    @check_errors.file_content.each_with_index do |str, idx|
      if !str.strip.empty? && str[-2] == ' '
        @errors << "Line: #{idx + 1}:#{str.size - 1}: Error: Trailing whitespace detected."
      end
    end
  end

  def check_end_error
    number_of_keywords = 0
    number_of_ends = 0
    @check_errors.file_content.each_with_index do |str, _idx|
      if @keywords.include?(str.split(' ').first) ||
         str.split(' ').include?('do')
        number_of_keywords += 1
      end
      number_of_ends += 1 if str.strip == 'end'
    end
    log_error_message("Lint/Syntax: Missing 'end'") if number_of_keywords > number_of_ends
    return unless number_of_keywords < number_of_ends

    log_error_message("Lint/Syntax: Unexpected 'end'")
  end

  def check_empty_line
    @check_errors.file_content.each_with_index do |str, idx|
      check_class_empty_line(str, idx)
      check_def_empty_line(str, idx)
      check_end_empty_line(str, idx)
      check_empty_line_do_block(str, idx)
    end
  end

  def check_indentation
    message = 'Use two spaces for indentation'
    current_value = 0
    indented_value = 0

    @check_errors.file_content.each_with_index do |str, idx|
      strip_line = str.strip.split(' ')
      expected_value = current_value * 2
      reserved_words = %w[class def if elsif until module unless begin case]

      next unless !str.strip.empty? || !strip_line.first.eql?('#')

      if reserved_words.include?(strip_line.first) ||
         strip_line.include?('do')
        indented_value += 1
      end
      indented_value -= 1 if str.strip == 'end'

      next if str.strip.empty?

      indentation_error(str, idx, expected_value, message)
      current_value = indented_value
    end
  end

  def check_tag_error
    tag_errors(/\{/, /\}/, '{', '}', 'Curly Bracket')
    tag_errors(/\[/, /\]/, '[', ']', 'Square Bracket')
    tag_errors(/\(/, /\)/, '(', ')', 'Parenthesis')
  end

  def no_error
    'No offenses'.colorize(:green)
  end
end
# rubocop: enable Metrics/CyclomaticComplexity
