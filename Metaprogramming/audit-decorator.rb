require 'logger'

class AuditDecorator01
  def initialize(object)
    @object = object
    @logger = Logger.new(STDOUT)
  end

  private

  def method_missing(name, *args, &blk)
    @logger.info "calling '#{name}' on #{@object.inspect}"
    @object.send name, *args, &blk
  end
end

class AuditDecorator02
  def initialize(object)
    @object = object
    @logger = Logger.new(STDOUT)

    mod = Module.new do
      object.public_methods.each do |name|
        define_method(name) do |*args, &blk|
          @logger.info "calling '#{name}' on #{@object.inspect}"
          @object.send name, *args, &blk
        end
      end
    end

    extend mod
  end
end
