class DeviceDetector
  class RegexCache
    attr_reader :data

    def initialize()
      @data = {}
    end

    def set(key, value)
      data[String(key)] = value
    end

    def get(key)
      data[String(key)]
    end

    def key?(string_key)
      data.key?(string_key)
    end

    def get_or_set(key, value = nil)
      string_key = String(key)

      if key?(string_key)
        get(string_key)
      else
        value = yield if block_given?
        set(string_key, value)
      end
    end
  end
end
