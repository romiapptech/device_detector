class DeviceDetector
  class Parser < Struct.new(:user_agent)

    ROOT = File.expand_path('../../..', __FILE__)

    def name
      NameExtractor.new(user_agent, regex_meta).call
    end

    def full_version
      VersionExtractor.new(user_agent, regex_meta).call
    end

    private

    def regex_meta
      @regex_meta ||= matching_regex || {}
    end

    def matching_regex
      regexes.find { |r| user_agent =~ r[:regex] }
    end

    def regexes
      @regexes ||= regexes_for(filepaths)
    end

    def filenames
      fail NotImplementedError
    end

    def filepaths
      filenames.map do |filename|
        [ filename.to_sym, File.join(ROOT, 'regexes', filename) ]
      end
    end

    def regexes_for(file_paths)
      #from_cache(['regexes', self.class]) do
        load_regexes(file_paths).flat_map { |path, regex| parse_regexes(path, regex) }
      #end
    end

    def load_regexes(file_paths)
      #puts "o no i'm hit!"
      file_paths.map { |path, full_path| [path, symbolize_keys!(YAML.load_file(full_path))] }
    end

    def symbolize_keys!(object)
      case object
      when Array
        object.map!{ |v| symbolize_keys!(v) }
      when Hash
        object.keys.each{ |k| object[k.to_sym] = symbolize_keys!(object.delete(k)) if k.is_a?(String) }
      end
      object
    end

    def parse_regexes(path, raw_regexes)
      raw_regexes.map do |meta|
        fail "invalid device spec: #{meta.inspect}" unless meta[:regex].is_a? String
        meta[:regex] = build_regex(meta[:regex])
        meta[:path] = path
        meta
      end
    end

    def build_regex(src)
      Regexp.new('(?:^|[^A-Z0-9\-_]|[^A-Z0-9\-]_|sprd-)(?:' + src + ')', Regexp::IGNORECASE)
    end

    def from_cache(key)
      DeviceDetector.cache.get_or_set(key) { yield }
    end
  end
end
