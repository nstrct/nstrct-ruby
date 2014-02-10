require 'digest/crc32'

module Nstrct

  class Frame

    class StartOfFrameInvalid < StandardError; end
    class EndOfFrameInvalid < StandardError; end
    class NoFrameAvailable < StandardError; end
    class ChecksumInvalid < StandardError; end

    FRAME_OVERHEAD = 8
    FRAME_START = 0x55
    FRAME_END = 0xAA

    def self.crc32(buffer)
      Digest::CRC32.checksum buffer
    end

    def self.available?(buffer)
      if buffer.size >= 1
        raise StartOfFrameInvalid unless buffer.slice(0).unpack('C')[0] == FRAME_START
        if buffer.size >= 3
          payload_length = buffer.slice(1..2).unpack('S>')[0]
          if buffer.size >= (payload_length + FRAME_OVERHEAD)
            raise EndOfFrameInvalid unless buffer.slice(payload_length + FRAME_OVERHEAD - 1).unpack('C')[0] == FRAME_END
            return true
          end
        end
      end
      false
    end

    def self.parse buffer
      raise NoFrameAvailable unless self.available?(buffer)
      buffer.slice!(0) # remove start of frame
      length = buffer.slice!(0..1).unpack('S>')[0]
      payload = buffer.slice!(0..length - 1)
      checksum = buffer.slice!(0..3).unpack('L>')[0]
      buffer.slice!(0) # remove end of frame
      raise ChecksumInvalid unless checksum == crc32(payload)
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
