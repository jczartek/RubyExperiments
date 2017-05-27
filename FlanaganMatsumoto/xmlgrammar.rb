class XMLGrammar
  # Create an instance of this class, specifying a stream or object to
  # hold the output. This can by any object that responds to <<(String).
  def initialize(out)
    @out = out
  end

  # Invoke the block an instance that outputs to the specified stream.
  def self.generate(out, &block)
    new(out).instance_eval(&block)
  end

  # Define an allowed element (or tag) in the grammar.
  # This class method is the grammar-specification DSL
  # and defines the methods that constitute the XML-output DSL.
  def self.element(tagname, attributes={})
    @allowed_attributes ||= {}
    @allowed_attributes[tagname] = attributes

    class_eval %Q{
      def #{tagname}(attributes={}, &block)
        tag(:#{tagname}, attributes,&block)
      end
    }
  end

  # These are constants used when defining attribute values
  OPT  = :opt   # for aptional attributes
  REQ  = :req   # for required attributes
  BOOL = :bool  # for attributes whose value is their own name

  def self.allowed_attributes
    @allowed_attributes
  end

  # Output the specified object as CDATA, return nil.
  def content(text)
    @out << text.to_s
  end

  # Output the specified object as a comment, return nil.
  def comment(text)
    @out << "<!-- #{text} -->"
  end

  # Output a tag with the specified name and attribute.
  # If there is a block, invoke it to output or return content.
  # Return nil.
  def tag(tagname, attributes={})
    # Output the tag name
    @out << "#{tagname}"


    # Get the allowed attributes for this tag.
    allowed = allowed = self.class.allowed_attributes[tagname]

    # First, make sure that each of the attributes is allowed.
    # Assuming they are allowed, output all of the specified ones.
    attributes.each_pair do |key, value|
      raise "unknown attributes: #{key}" unless allowed.include?(key)
      @out << "#{key}='#{value}'"
    end

    # Now look through the allowed attributes, checking for
    # required attributes that were omitted and for attributes with
    # default values that we can output.
    allowed.each_pair do |key, value|
      # If this attributes was already output, do nothing.
      next if attributes.has_key? key
      if (value == REQ)
        raise "required attributes '#{key}' missing in <#{tagname}>"
      elsif value.is_a? String
        @out << "key='#{value}'"
      end
    end

    if block_given?
      # This block has content
      @out << '>'                  # End the opening tag
      content = yield
      if content
        @out << content.to_s
      end
      @out << "</#{tagname}>"      # Close the tag
    else
      @out << '/>'
    end
    nil
  end
end
