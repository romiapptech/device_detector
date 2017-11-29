class DeviceDetector
  class Client < Parser

    def known?
      regex_meta.any?
    end

    private

    def filenames
      [
        'client/browsers.yml'
      ]
    end
  end
end
