require_relative '../lib/error_checker'

describe ErrorChecker do
  let(:error_cherker) { ErrorChecker.new('text_with_errors.txt') }

  context '#check_white_trailing_spaces' do
    example 'should return trailing whitespace detected on line 1' do
      error_cherker.check_white_trailing_spaces
      expect(error_cherker.errors[0]).to eql('Line: 1:17: Error: Trailing whitespace detected.')
    end
  end

  context '#check_white_trailing_spaces' do
    example 'should return nil when no white space is detected line 1' do
      error_cherker.check_white_trailing_spaces
      expect(error_cherker.errors[0]).to eql(nil)
    end
  end

  context '#check_indentation' do
    example 'should return indentation errror on line 28' do
      error_cherker.check_indentation
      expect(error_cherker.errors[5]).to eql('line:28 Use two spaces for indentation')
    end
  end

  context '#check_indentation' do
    example 'should return nil when there is no identation error on line 28' do
      error_cherker.check_indentation
      expect(error_cherker.errors[5]).to eql(nil)
    end
  end

  context '#check_tag_error' do
    example "returns missing/unexpected or missing '{' " do
      error_cherker.check_tag_error
      expect(error_cherker.errors[0]).to eql(error_cherker.errors[0])
    end
  end

  context '#check_tag_error' do
    example "returns nil when there no missing or unexpected '{' " do
      error_cherker.check_tag_error
      expect(error_cherker.errors[0]).to eql(nil)
    end
  end

  context '#check_end_error' do
    example 'returns missing/unexpected end' do
      error_cherker.check_end_error
      expect(error_cherker.errors[0]).to eql("Lint/Syntax: Missing 'end'")
    end
  end

  context '#check_end_error' do
    example 'returns nil when there is missing/unexpeced end' do
      error_cherker.check_end_error
      expect(error_cherker.errors[0]).to eql(nil)
    end
  end

  context '#check_empty_line' do
    example 'returns empty line error' do
      error_cherker.check_empty_line
      expect(error_cherker.errors[2]).to eql('line:24 Extra empty line detected at the end of the block body')
    end
  end

  context '#check_empty_line' do
    example 'returns nil when there no empty line error' do
      error_cherker.check_empty_line
      expect(error_cherker.errors[2]).to eql(nil)
    endk body'
  end
end
