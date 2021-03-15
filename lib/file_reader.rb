require 'colorize'

class FileReader
  attr_reader :file_path, :file_content, :file_lines, :error_message

  def initialize(file_path)
    @file_path = file_path
    @error_message = ' '
    begin
      @file_content = File.readlines(@file_path)
      @file_lines = @file_content.size
    rescue StandardError 
      @file_content = []
      @error_message = "File path incorrect, check you file path and try again\n".colorize(:red)
    end
  end
end
