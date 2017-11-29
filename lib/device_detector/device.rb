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
        'device/portable_media_player.yml',
        'device/mobiles.yml',
      ]
    end

    def matching_regex
      regex = regexes.find { |r| user_agent =~ r[:regex] }
      if regex && regex[:models]
        model_regex = regex[:models].find { |m| user_agent =~ m[:regex]}
        if model_regex
          regex = regex.merge(:regex_model => model_regex[:regex], :model => model_regex[:model], :brand => model_regex[:brand])
          regex[:device] = model_regex[:device] if model_regex.key?(:device)
          regex.delete(:models)
        end
      end
      regex
    end

    def parse_regexes(path, raw_regexes)
      raw_regexes.map do |brand, meta|
        fail "invalid device spec: #{meta.inspect}" unless meta[:regex].is_a? String
        meta[:regex] = build_regex(meta[:regex])
        if meta.key?(:models)
          meta[:models].each do |model|
            fail "invalid model spec: #{model.inspect}" unless model[:regex].is_a? String
            model[:regex] = build_regex(model[:regex])
            model[:brand] = brand.to_s unless model[:brand]
          end
        end
        meta[:path] = path
        meta
      end
    end

  end
end
