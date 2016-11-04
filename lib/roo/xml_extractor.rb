module Roo
  class XmlExtractor < Ox::Sax
    def initialize(name, &block)
      @name = name.to_sym
      @block = block
      @stack = []
    end

    def start_element(name, attrs = [])
      if @stack.any? or @name == name
        @stack << Ox::Element.new(name)
      end
    end

    def end_element(name)
      if @stack.any?
        element = @stack.pop
        if @stack.any?
          @stack.last << element
        else
          @block.call(element)
        end
      end
    end

    def attr(name, value)
      if @stack.any?
        @stack.last[name] = value
      end
    end

    def text(string)
      if @stack.any?
        @stack.last << string
      end
    end
  end
end
