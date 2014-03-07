module Nstrct

  class Argument

    # Available datatypes and their argument code
    DATATYPES = {
      boolean: 1,
      int8: 10,
      int16: 11,
      int32: 12,
      int64: 13,
      uint8: 14,
      uint16: 15,
      uint32: 16,
      uint64: 17,
      float32: 21,
      float64: 22,
      string: 31,
      array: 32
    }

    # Get the datatype of a argument code
    def self.datatype_by_for_argument_code code
      DATATYPES.detect{ |k,v| v == code }[0]
    end

    # Parse a single value of a buffer
    def self.parse_value datatype, data
      case datatype
        when :boolean
          return data.slice!(0).unpack('C')[0] == 1
        when :int8
          return data.slice!(0).unpack('c')[0]
        when :int16
          return data.slice!(0..1).unpack('s>')[0]
        when :int32
          return data.slice!(0..3).unpack('l>')[0]
        when :int64
          return data.slice!(0..7).unpack('q>')[0]
        when :uint8
          return data.slice!(0).unpack('C')[0]
        when :uint16
          return data.slice!(0..1).unpack('S>')[0]
        when :uint32
          return data.slice!(0..3).unpack('L>')[0]
        when :uint64
          return data.slice!(0..7).unpack('Q>')[0]
        when :float32
          return data.slice!(0..3).unpack('g')[0]
        when :float64
          return data.slice!(0..7).unpack('G')[0]
        when :string
          length = data.slice!(0).unpack('C')[0]
          return length > 0 ? data.slice!(0..length-1) : ''
        when :array
          raise 'cannot parse array value directly'
        else
          raise "datatype '#{datatype}' not recognized"
      end
    end

    # Parse a single argument from a buffer
    def self.parse data
      datatype = self.datatype_by_for_argument_code(data.slice!(0).unpack('C')[0])
      if datatype == :array
        array_datatype = self.datatype_by_for_argument_code(data.slice!(0).unpack('C')[0])
        array_num_elements = data.slice!(0).unpack('C')[0]
        values = []
        array_num_elements.times do
          values << self.parse_value(array_datatype, data)
        end
        return self.new(array_datatype, values, true)
      else
        return self.new(datatype, self.parse_value(datatype, data), false)
      end
    end

    attr_reader :datatype, :value, :array

    # Instantiate a new Argument providing its datatype, value and arrayness
    def initialize datatype, value, array
      @datatype, @value, @array = datatype.to_sym, value, array
    end

    # Pack a single value in a buffer
    def pack_value datatype, value, data
      case datatype
        when :boolean
          data += [to_boolean(value) ? 1 : 0].pack('C')
        when :int8
          data += [value.to_i].pack('c')
        when :int16
          data += [value.to_i].pack('s>')
        when :int32
          data += [value.to_i].pack('l>')
        when :int64
          data += [value.to_i].pack('q>')
        when :uint8
          data += [value.to_i].pack('C')
        when :uint16
          data += [value.to_i].pack('S>')
        when :uint32
          data += [value.to_i].pack('L>')
        when :uint64
          data += [value.to_i].pack('Q>')
        when :float32
          data += [value.to_f].pack('g')
        when :float64
          data += [value.to_f].pack('G')
        when :string
          data += [value.to_s.size].pack('C')
          data += value.to_s
        when :array
          raise 'cannot pack array value directly'
        else
          raise "datatype '#{datatype}' not recognized"
      end
      data
    end

    def to_boolean(value)
      return value if value.is_a?(TrueClass) || value.is_a?(FalseClass)
      return Integer(value) >= 1
    rescue
      return value == 'true'
    end

    # Pack a single argument in a buffer
    def pack
      data = ''
      if @array
        data += [DATATYPES[:array]].pack('C')
        data += [DATATYPES[@datatype]].pack('C')
        if @value.is_a?(Array)
          data += [@value.size].pack('C')
          @value.each do |val|
            data = pack_value(@datatype, val, data)
          end
        else
          data += [0].pack('C')
        end
      else
        data += [DATATYPES[datatype]].pack('C')
        data = pack_value(@datatype, @value, data)
      end
      data
    end

    # Return comparable inspection
    def inspect
      if @array
        "[#{@datatype.inspect}]=#{@value}"
      else
        "#{@datatype.inspect}=#{@value}"
      end
    end

  end

end
