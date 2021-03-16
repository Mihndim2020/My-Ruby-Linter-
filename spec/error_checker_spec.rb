require_relative '../lib/error_checker'

describe ErrorChecker do
  let(:error_cherker) { ErrorChecker.new('text_with_errors.txt') }

  context '#check_white_trailing_spaces' do
    example 'should return trailing whitespace detected on line 1' do
      error_cherker.check_white_trailing_spaces
      expect(error_cherker.errors[0]).to eql('Line: 1:18: Error: Trailing whitespace detected.')
    end
  end

  context '#check_indentation' do
end