require 'colorize'
require 'strscan'
require_relative 'file_reader.rb'

class ErrorChecker
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
end 