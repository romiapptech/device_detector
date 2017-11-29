require 'yaml'

require_relative './device_detector/version'
require_relative './device_detector/metadata_extractor'
require_relative './device_detector/version_extractor'
require_relative './device_detector/model_extractor'
require_relative './device_detector/name_extractor'
require_relative './device_detector/regex_cache'
require_relative './device_detector/parser'
require_relative './device_detector/device'
require_relative './device_detector/os'

class DeviceDetector

  attr_reader :user_agent

  def initialize(user_agent)
    @user_agent = user_agent
  end

  def os_name
    os.name
  end

  def os_full_version
    os.full_version
  end

  def device_name
    device.name
  end

  def device_type
    t = device.type

    if t.nil? && android_tablet_fragment? || opera_tablet?
      t = 'tablet'.freeze
    end

    if t.nil? && android_mobile_fragment?
      t = 'smartphone'.freeze
    end

    # Android up to 3.0 was designed for smartphones only. But as 3.0,
    # which was tablet only, was published too late, there were a
    # bunch of tablets running with 2.x With 4.0 the two trees were
    # merged and it is for smartphones and tablets
    #
    # So were are expecting that all devices running Android < 2 are
    # smartphones Devices running Android 3.X are tablets. Device type
    # of Android 2.X and 4.X+ are unknown
    if t.nil? && os.short_name == 'AND'.freeze && os.full_version && !os.full_version.empty?
      if os.full_version < '2'.freeze
        t = 'smartphone'.freeze
      elsif os.full_version >= '3'.freeze && os.full_version < '4'.freeze
        t = 'tablet'.freeze
      end
    end

    # All detected feature phones running android are more likely a smartphone
    if t == 'feature phone'.freeze && os.family == 'Android'.freeze
      t = 'smartphone'.freeze
    end

    # According to http://msdn.microsoft.com/en-us/library/ie/hh920767(v=vs.85).aspx
    # Internet Explorer 10 introduces the "Touch" UA string token. If this token is present at the end of the
    # UA string, the computer has touch capability, and is running Windows 8 (or later).
    # This UA string will be transmitted on a touch-enabled system running Windows 8 (RT)
    #
    # As most touch enabled devices are tablets and only a smaller part are desktops/notebooks we assume that
    # all Windows 8 touch devices are tablets.
    if t.nil? && touch_enabled? &&
       (os.short_name == 'WRT'.freeze || (os.short_name == 'WIN'.freeze && os.full_version && os.full_version >= '8'.freeze))
      t = 'tablet'.freeze
    end

    # set device type to desktop for all devices running a desktop os that were
    # not detected as an other device type
    if t.nil? && os.desktop?
      t = 'desktop'.freeze
    end

    t
  end

  def known?
    client.known?
  end

  class << self

    def cache
      @cache ||= RegexCache.new()
    end

  end

  private

  def device
    @device ||= Device.new(user_agent)
  end

  def os
    @os ||= OS.new(user_agent)
  end

  def android_tablet_fragment?
    user_agent =~ build_regex('Android; Tablet;'.freeze)
  end

  def android_mobile_fragment?
    user_agent =~ build_regex('Android; Mobile;'.freeze)
  end

  def touch_enabled?
    user_agent =~ build_regex('Touch'.freeze)
  end

  def opera_tablet?
    user_agent =~ build_regex('Opera Tablet'.freeze)
  end

  def build_regex(src)
    Regexp.new('(?:^|[^A-Z0-9\_\-])(?:' + src + ')', Regexp::IGNORECASE)
  end
end
