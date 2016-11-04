require 'bundler/setup'

require 'roo'
require 'ruby-prof'
require 'benchmark'

TESTDIR =  File.join(File.dirname(__FILE__), 'files')

Benchmark.bmbm do |bm|
  spreadsheet = Roo::Spreadsheet.open(File.join(TESTDIR, "Bibelbund.xlsx"))

  bm.report "streaming" do
    # RubyProf.start

    i = 0
    spreadsheet.each_row_streaming do |row|
      i+=row.to_a.size
    end
    p i

    # result = RubyProf.stop
    #
    # printer = RubyProf::FlatPrinter.new(result)
    # printer.print(STDOUT)

  end
end
