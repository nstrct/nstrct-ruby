# nstrct-ruby [![Build Status](https://travis-ci.org/nstrct/nstrct-ruby.png?branch=master)](https://travis-ci.org/nstrct/nstrct-ruby) [![Code Climate](https://codeclimate.com/github/nstrct/nstrct-ruby.png)](https://codeclimate.com/github/nstrct/nstrct-ruby)

**a multi-purpose binary protocol for instruction interchange**

Interchange formats like json or xml are great to keep data visible, but due to their parse and pack complexity they aren't used in embedded applications. There are alternatives like msgpack or Google's protocol buffer, which allow a more binary representation of data, but these protcols are still heavy and developers tend to rather implement their own 'simple' binary protocols instead of porting or using the big ones. 

The protcol **nstrct** is designed to be an alternative in those situations where a tiny and versatile protocol is needed. The main transportable unit in nstrct are **instructions** which carry a dynamic amount of data in the form of **arguments**. Each instruction is identified by a code between 0-65535 which can be used by two communicating applications to identify the blueprint of the message. Arguments support all standard types of integers(boolean, int8-64, uint8-64, float32/64), strings, and arrays of integers or strings. There is no support for hashes by design to keep the pack and unpacking functions as small as possible. [Check the main repository for the binary layout of the instructions](http://github.com/nstrct/nstrct).

**Start using nstrct by getting the library for your favorite programming language:**

* [C/C++ (nstrct-c)](http://github.com/nstrct/nstrct-c)
* [Ruby (nstrct-ruby)](http://github.com/nstrct/nstrct-ruby)
* [Obj-C (nstrct-objc)](http://github.com/nstrct/nstrct-objc)
* [Java (nstrct-c)](http://github.com/nstrct/nstrct-java)

_This software has been open sourced by [ElectricFeel Mobility Systems Gmbh](http://electricfeel.com) and is further maintained by [Joël Gähwiler](http://github.com/256dpi)._

## Instruction Composing

A simple example:

```ruby
instruction = Nstrct::Instruction.new(382)
bytes = instruction.pack
```

A more complex example:

```ruby
instruction = Nstrct::Instruction.build_instruction(232, [:boolean, true], [:int8, 2], [:float32, 1.0], [[:uint16], [54, 23, 1973]])
instruction.pack
```

## Instruction Processing

```ruby
instruction = Nstrct::Instruction.parse(bytes)
instruction.code
instruction.arguments[0].datatype
```
