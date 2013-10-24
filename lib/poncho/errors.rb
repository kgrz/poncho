module Poncho
  class Errors
    attr_reader :messages

    def initialize(base)
      @base     = base
      @messages = {}
    end

    # Clear the messages
    def clear
      messages.clear
    end

    # Do the error messages include an error with key +error+?
    def include?(error)
      (v = messages[error]) && v.any?
    end
    alias_method :has_key?, :include?

    # Get messages for +key+
    def get(key)
      messages[key]
    end

    # Set messages for +key+ to +value+
    def set(key, value)
      messages[key] = value
    end

    # Delete messages for +key+
    def delete(key)
      messages.delete(key)
    end

    # When passed a symbol or a name of a method, returns an array of errors
    # for the method.
    #
    #   p.errors[:name]   # => ["can not be nil"]
    #   p.errors['name']  # => ["can not be nil"]
    def [](attribute)
      get(attribute.to_sym) || set(attribute.to_sym, [])
    end

    # Adds to the supplied attribute the supplied error message.
    #
    #   p.errors[:name] = "must be set"
    #   p.errors[:name] # => ['must be set']
    def []=(attribute, error)
      self[attribute] << error
    end

    def each
      [to_s]
    end

    # Returns the number of error messages.
    #
    #   p.errors.add(:name, "can't be blank")
    #   p.errors.size # => 1
    #   p.errors.add(:name, "must be specified")
    #   p.errors.size # => 2
    def size
      values.flatten.size
    end

    # Returns all message values
    def values
      messages.values
    end

    # Returns all message keys
    def keys
      messages.keys
    end

    def to_s
      "Validation errors:\n " + full_messages.join(', ')
    end

    # Returns an array of error messages, with the attribute name included
    #
    #   p.errors.add(:name, "can't be blank")
    #   p.errors.add(:name, "must be specified")
    #   p.errors.to_a # => ["name can't be blank", "name must be specified"]
    def to_a
      full_messages
    end

    # Returns the number of error messages.
    #   p.errors.add(:name, "can't be blank")
    #   p.errors.count # => 1
    #   p.errors.add(:name, "must be specified")
    #   p.errors.count # => 2
    def count
      to_a.size
    end

    # Returns true if no errors are found, false otherwise.
    # If the error message is a string it can be empty.
    def empty?
      messages.all? { |k, v| v && v == "" && !v.is_a?(String) }
    end
    alias_method :blank?, :empty?

    # Return the first error we get
    def as_json(options=nil)
      return {} if messages.empty?
      attribute, types = messages.first
      type             = types.first

      {
        :error => {
          :param => attribute,
          :type  => type,
          :message => nil
        }
      }
    end

    def to_json(*)
      MultiJson.dump as_json
    end

    def to_hash
      messages.dup
    end

    def add(attribute, message = nil, options = {})
      self[attribute] << message
    end

    def full_messages
      messages.map { |attribute, message| full_message(attribute, message) }
    end

    def full_message(attribute, message)
      return message if attribute == :base
      "#{attribute} #{message.join(', ')}"
    end
  end
end
