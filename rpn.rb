#! /usr/bin/env ruby
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'clamp'
require 'evaluator'

$stdout.sync = true
$stderr.sync = true

Clamp do
  option ['-v', '--verbose'], :flag, 'enable debugging'
  option ['-f', '--input'], 'INPUT_CSV', 'Input CSV File', required: true
  option ['-o', '--output'], 'OUTPUT_CSV', 'Output CSV File'

  def execute
    evaluator = Evaluator.new(input, output)
    evaluator.run
  end
end
