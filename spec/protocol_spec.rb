require 'spec_helper'

describe Nstrct::Instruction do

  it 'should pack and unpack an empty instruction' do
    instruction1 = Nstrct::Instruction.new(382, [])
    instruction2 = Nstrct::Instruction.parse(instruction1.pack)
    instruction1.inspect.should == instruction2.inspect
  end

  it 'should pack and unpack an instructionw with arguments' do
    instruction1 = Nstrct::Instruction.build(232, [:float32, 1.0 ], [:boolean, true], [:int8, 2], [:float32, 1.0], [[:uint16], [54, 23, 1973]])
    puts instruction1.pack.unpack('C*').inspect
    instruction2 = Nstrct::Instruction.parse(instruction1.pack)
    instruction1.inspect.should == instruction2.inspect
  end

end
