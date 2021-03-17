# rubocop: disable Metrics/CyclomaticComplexity

require 'colorize'
require 'strscan'
require_relative 'file_reader'
require_relative 'error_types'

class ErrorChecker
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

  private

  def indentation_error(str, idx, expected_value, message)
    strip_line = str.strip.split(' ')
    str_match = str.match(/^\s*\s*/)
    end_check = str_match[0].size.eql?(expected_value.zero? ? 0 : expected_value - 2)

    if str.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
      log_error_message("line:#{idx + 1} #{message}") unless end_check
    elsif !str_match[0].size.eql?(expected_value)
      log_error_message("line:#{idx + 1} #{message}")
    end
  end

  def tag_errors(*args)
    @check_errors.file_content.each_with_index do |str, idx|
      open_paren = []
      close_paren = []
      open_paren << str.scan(args[0])
      close_paren << str.scan(args[1])

      status = open_paren.flatten.size <=> close_paren.flatten.size

      if status.eql?(1)
        log_error_message("line:#{idx + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}")
      end
      if status.eql?(-1)
        log_error_message("line:#{idx + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}")
      end
    end
  end

  def check_end_empty_line(str, idx)
    return unless str.strip.split(' ').first.eql?('end')

    return unless @check_errors.file_content[idx - 1].strip.empty?

    log_error_message("line:#{idx} Extra empty line detected at the end of the block body")
  end

  def check_empty_line_do_block(str, idx)
    message = 'Extra empty line detected at the beginning of the block'
    return unless str.strip.split(' ').include?('do')

    log_error_message("line:#{idx + 2} #{message}") if @check_errors.file_content[idx + 1].strip.empty?
  end

  def check_class_empty_line(str, idx)
    msg = 'Extra empty line detected at class body beginning'
    return unless str.strip.split(' ').first.eql?('class')

    log_error_message("line:#{idx + 2} #{msg}") if @check_errors.file_content[idx + 1].strip.empty?
  end

  def check_def_empty_line(str, idx)
    message1 = 'Extra empty line detected at the beginning of the method body'
    message2 = 'Extra empty line detected between method definiton'

    return unless str.strip.split(' ').first.eql?('def')

    log_error_message("line:#{idx + 2} #{message1}") if @check_errors.file_content[idx + 1].strip.empty?

    return unless @check_errors.file_content[idx - 1].strip.split(' ').first.eql?('end')

    log_error_message("line:#{idx + 1} #{message2}")
  end

  def log_error_message(error_msg)
    @errors << error_msg
  end
end
# rubocop: enable Metrics/CyclomaticComplexity
