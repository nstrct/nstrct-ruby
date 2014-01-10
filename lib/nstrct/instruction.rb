module Nstrct

  class Instruction

    attr_accessor :code, :arguments

    # Parse one message from the data stream.
    def self.parse data
      code = data.slice!(0..1).unpack('s>')[0]
      num_arguments = data.slice!(0).unpack('C')[0]
      data.slice!(0..1) # num_array_elements
      arguments = []
      num_arguments.times do
        arguments << Nstrct::Argument.parse(data)
      end
      self.new(code, arguments)
    end

    # Build an instruction for a code and some arguments.
    #
    #   Message.build_instruction 54, [ :boolean, true], [[:int8], [7, 8, 9]] ]
    #
    def self.build code, *args
      arguments = []
      args.each do |arg|
        if arg[0].is_a?(Array)
          arguments << Nstrct::Argument.new(arg[0][0], arg[1], true)
        else
          arguments << Nstrct::Argument.new(arg[0], arg[1], false)
        end
      end
      self.new(code, arguments)
    end

    # Instantiate a new instruction by its code and alist of arguments
    def initialize code, arguments=[]
      @code, @arguments = code, arguments
    end

    # Get all the arguments values
    def argument_values
      @arguments.map{ |arg| arg.value }
    end

    # get all elements in arrays
    def array_elements
      @arguments.inject(0){ |sum, a| sum + (a.array ? a.value.size : 0) }
    end

    # Pack a single instruction in a buffer
    def pack
      message = [@code].pack('s>')
      message += [@arguments.size].pack('C')
      message += [array_elements].pack('s>')
      @arguments.each do |arg|
        message += arg.pack
      end
      message
    end

    # Return a comparable inspection
    def inspect
      "#<Nstrct::Instructon code=#{@code.inspect}, arguments=#{@arguments.inspect}>"
    end

  end

end
