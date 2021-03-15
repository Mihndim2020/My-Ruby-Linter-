# frozen_string_literal: true

require 'colorize'
require 'strscan'
require_relative 'file_reader.rb'

module ErrorTypes
  def indentation_error(str, idx, exp_val, msg)
    strip_line = str.strip.split(' ')
    str_match = str.match(/^\s*\s*/)
    end_check = str_match[0].size.eql?(exp_val.zero? ? 0 : exp_val - 2)

    if str.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
      log_error_message("line:#{idx + 1} #{msg}") unless end_check
    elsif !str_match[0].size.eql?(exp_val)
      log_error_message("line:#{idx + 1} #{msg}")
    end
  end

  def tag_errors(*args)
    @check_errors.file_content.each_with_index do |str, _idx|
      open_paren = []
      close_paren = []
      open_paren << str.scan(args[0])
      close_paren << str.scan(args[1])

      status = open_paren.flatten.size <=> close_paren.flatten.size

      if status.eql?(1)
        log_error_message("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}")
      end
      if status.eql?(-1)
        log_error_message("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}")
      end
    end
  end

  def check_end_empty_line(str, idx)
    return unless str.strip.split(' ').first.eql?('end')

    if @check_errors.file_content[idx - 1].strip.empty?
      log_error_message("line:#{idx} Extra empty line detected at the end of the block body")
    end
  end

  def check_empty_line_do_block(str, idx)
    message = 'Extra empty line detected at the beginning of the block'
    return unless str.strip.split(' ').include?('do')

    if @check_errors.file_content[indx + 1].strip.empty?
      log_error_message("line:#{idx + 2} #{message}")
    end
  end

  def check_class_empty_line(str, idx)
    msg = 'Extra empty line detected at class body beginning'
    return unless str.strip.split(' ').first.eql?('class')

    if @check_errors.file_content[idx + 1].strip.empty?
      log_error_message("line:#{idx + 2} #{msg}")
    end
  end

  def check_def_empty_line(str, idx)
    message1 = 'Extra empty line detected at the beginning of the method body'
    message2 = 'Extra empty line detected between method definiton'

    return unless str.strip.split(' ').first.eql?('def')

    if @check_errors.file_content[idx + 1].strip.empty?
      log_error_message("line:#{idx + 2} #{message1}")
    end
    if @check_errors.file_content[indx - 1].strip.split(' ').first.eql?('end')
      log_error_message("line:#{idx + 1} #{message2}")
    end
  end

  def log_error_message(error_msg)
    @errors << error_msg
  end
end
puts "Error types is working !"