require 'spec_helper'

describe Nstrct::Argument do

  it 'should coerce string booleans' do
    expect(Nstrct::Argument.new(:boolean, 'true', false).pack).to eq("\x01\x01")
    expect(Nstrct::Argument.new(:boolean, 'false', false).pack).to eq("\x01\x00")
    expect(Nstrct::Argument.new(:boolean, true, false).pack).to eq("\x01\x01")
    expect(Nstrct::Argument.new(:boolean, false, false).pack).to eq("\x01\x00")
    expect(Nstrct::Argument.new(:boolean, 1, false).pack).to eq("\x01\x01")
    expect(Nstrct::Argument.new(:boolean, 0, false).pack).to eq("\x01\x00")
    expect(Nstrct::Argument.new(:boolean, 2, false).pack).to eq("\x01\x01")
  end

  it 'should treat wrong arrays' do
    Nstrct::Argument.new(:boolean, 'no-array-value', true).pack.should == " \x01\x00"
  end

end

describe Nstrct::Instruction do

  it 'should pack and unpack an empty instruction' do
    instruction1 = Nstrct::Instruction.new(382, [])
    instruction2 = Nstrct::Instruction.parse(instruction1.pack)
    expect(instruction1.inspect).to eq(instruction2.inspect)
  end

  it 'should pack and unpack an instructionw with arguments' do
    instruction1 = Nstrct::Instruction.build(232, [:float32, 1.0 ], [[:boolean], []], [:boolean, true], [:int8, 2], [:float32, 1.0], [[:uint16], [54, 23, 1973]])
    instruction2 = Nstrct::Instruction.parse(instruction1.pack)
    expect(instruction1.inspect).to eq(instruction2.inspect)
  end

end

describe Nstrct::Frame do

  it 'should pack and unpack a frame' do
    frame1 = Nstrct::Frame.new(Nstrct::Instruction.new(132, []))
    frame2 = Nstrct::Frame.parse(frame1.pack)
    expect(frame1.inspect).to eq(frame2.inspect)
  end

  describe 'errors' do

    let(:frame) { Nstrct::Frame.new(Nstrct::Instruction.new(132, [])) }

    it 'should raise start of frame invalid' do
      expect { Nstrct::Frame.parse('hello') }.to raise_error Nstrct::Frame::StartOfFrameInvalid
    end

    it 'should raise end of frame invalid' do
      data = frame.pack
      data[-1] = 'B'
      expect { Nstrct::Frame.parse(data) }.to raise_error Nstrct::Frame::EndOfFrameInvalid
    end

    it 'should raise no frame available' do
      data = frame.pack.slice(-1..-4)
      expect { Nstrct::Frame.parse(data) }.to raise_error Nstrct::Frame::NoFrameAvailable
    end

    it 'should raise checksum invalid' do
      data = frame.pack
      data[-2] = 'C'
      expect { Nstrct::Frame.parse(data) }.to raise_error Nstrct::Frame::ChecksumInvalid
    end

  end

end
