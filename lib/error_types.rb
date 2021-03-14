module ErrorTypes 
  def indentation_error(str, idx, exp_val, msg)
    strip_line = str.strip.split(' ')
    str_match = str.match(/^\s*\s*/)
    end_check = str_match[0].size.eql?(exp_val.zero? ? 0 : exp_val - 2)

    if str.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when' 
      log_error("line:#{idx + 1} #{msg}") unless end_check 
    elsif !str_match[0].size.eql?(exp_val)
      log_error("line:#{idx + 1} #{msg}")  
    end  
  end

  def tag_errors(*args)
    @check_errors.file_content.each_with_index do |str, idx|
      open_paren = []
      close_paren = []
      open_paren << str.scan(args[0])
      close_paren << str.scan(args[1])

    status = open_paren.flatten.size <=> close_paren.flatten.size

    log_error("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}") if status.eql?(1)
    log_error("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}") if status.eql?(-1)
    end
  end

end