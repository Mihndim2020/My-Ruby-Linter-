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

end