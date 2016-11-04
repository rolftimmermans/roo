module Roo
  class XmlExtractor < Nokogiri::XML::SAX::Document
    def initialize(name, &block)
      @name = name
      @block = block
      @stack = []
    end

    def start_element(name, attrs = [])
      if @stack.any? or @name == name
        element = Nokogiri::XML::Element.new(name, Nokogiri::XML::Document.new)
        attrs.each do |key, value|
          element[key] = value
        end
        @stack << element
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

    def characters(string)
      if @stack.any?
        @stack.last << string
      end
    end

    alias_method :cdata_block, :characters
  end
end
