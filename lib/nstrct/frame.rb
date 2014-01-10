require 'digest/crc32'

module Nstrct

  class Frame

    FRAME_START = 85
    FRAME_END = 170

    def self.crc32 buffer
      Digest::CRC32.checksum buffer
    end

    def self.available? buffer
      buffer.size >= 3 && buffer.size >= (buffer.slice(1..2).unpack('S>')[0]+6)
    end

    def self.parse buffer
      raise 'no frame available' unless self.available?(buffer)
      raise 'start of frame invalid' unless buffer.slice!(0).unpack('C')[0] == FRAME_START
      length = buffer.slice!(0..1).unpack('S>')[0]
      payload = buffer.slice!(0..length-1)
      checksum = buffer.slice!(0..3).unpack('L>')[0]
      raise 'checksum invalid' unless checksum == crc32(payload)
      raise 'end of frame invalid' unless buffer.slice!(0).unpack('C')[0] == FRAME_END
      self.new(Instruction.parse(payload))
    end

    attr_accessor :instruction

    def initialize instruction
      @instruction = instruction
    end

    def pack
      payload = @instruction.pack
      frame = [FRAME_START].pack('C')
      frame += [payload.size].pack('S>')
      frame += payload
      frame += [Frame.crc32(payload)].pack('L>')
      frame + [FRAME_END].pack('C')
    end

    # Return a comparable inspection
    def inspect
      "#<Nstrct::Frame instruction=#{@instruction.inspect}>"
    end

  end

end
