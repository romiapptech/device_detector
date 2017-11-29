class DeviceDetector
  class Device < Parser

    def known?
      regex_meta.any?
    end

    def name
      ModelExtractor.new(user_agent, regex_meta).call
    end

    def type
      regex_meta[:device]
    end

    def brand
      regex_meta[:brand]
    end

    private

    # The order of files needs to be the same as the order of device
    # parser classes used in the piwik project.
    def filenames
      [
        'device/mobiles.yml'
      ]
    end

    def matching_regex
      regex = regexes.find { |r| user_agent =~ r[:regex] }
      regex
    end

    def parse_regexes(path, raw_regexes)
      raw_regexes.map do |brand, meta|
        fail "invalid device spec: #{meta.inspect}" unless meta[:regex].is_a? String
        meta[:regex] = build_regex(meta[:regex])
        meta[:path] = path
        meta
      end
    end

  end
end
