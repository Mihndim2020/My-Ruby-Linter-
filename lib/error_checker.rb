require 'colorize'
require 'strscan'
require_relative 'file_reader.rb'

class ErrorChecker
  attr_reader :check_errors, :errors

  def initialize(file_path)
    @check_errors = FileReader.new(file_path)
    @errors = []
    @keywords = %w[begin case class def do if module unless while]
  end
end 