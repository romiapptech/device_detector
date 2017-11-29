require 'set'

class DeviceDetector
  class OS < Parser

    def name
      os_info[:name]
    end

    def short_name
      os_info[:short]
    end

    def family
      os_info[:family]
    end

    def desktop?
      DESKTOP_OSS.include?(family)
    end

    def full_version
      raw_version = super.to_s.split('_'.freeze).join('.'.freeze)
      raw_version == '' ? nil : raw_version
    end

    private

    def os_info
      os_name = NameExtractor.new(user_agent, regex_meta).call
      if os_name
        os_name.downcase!
        short = DOWNCASED_OPERATING_SYSTEMS[os_name]
      end
      
      short = 'UNK'.freeze if short == nil
      { name: os_name, short: short, family: FAMILY_TO_OS[short] }
    end

    DESKTOP_OSS = Set.new(['AmigaOS', 'IBM', 'GNU/Linux', 'Mac', 'Unix', 'Windows', 'BeOS', 'Chrome OS'])

    # OS short codes mapped to long names
    # OPERATING_SYSTEMS = {
    #     'AIX' => 'AIX',
    #     'AND' => 'Android',
    #     'AMG' => 'AmigaOS',
    #     'ATV' => 'Apple TV',
    #     'ARL' => 'Arch Linux',
    #     'BTR' => 'BackTrack',
    #     'SBA' => 'Bada',
    #     'BEO' => 'BeOS',
    #     'BLB' => 'BlackBerry OS',
    #     'QNX' => 'BlackBerry Tablet OS',
    #     'BMP' => 'Brew',
    #     'CES' => 'CentOS',
    #     'COS' => 'Chrome OS',
    #     'CYN' => 'CyanogenMod',
    #     'DEB' => 'Debian',
    #     'DFB' => 'DragonFly',
    #     'FED' => 'Fedora',
    #     'FOS' => 'Firefox OS',
    #     'BSD' => 'FreeBSD',
    #     'GNT' => 'Gentoo',
    #     'GTV' => 'Google TV',
    #     'HPX' => 'HP-UX',
    #     'HAI' => 'Haiku OS',
    #     'IRI' => 'IRIX',
    #     'INF' => 'Inferno',
    #     'KNO' => 'Knoppix',
    #     'KBT' => 'Kubuntu',
    #     'LIN' => 'GNU/Linux',
    #     'LBT' => 'Lubuntu',
    #     'VLN' => 'VectorLinux',
    #     'MAC' => 'Mac',
    #     'MAE' => 'Maemo',
    #     'MDR' => 'Mandriva',
    #     'SMG' => 'MeeGo',
    #     'MCD' => 'MocorDroid',
    #     'MIN' => 'Mint',
    #     'MLD' => 'MildWild',
    #     'MOR' => 'MorphOS',
    #     'NBS' => 'NetBSD',
    #     'MTK' => 'MTK / Nucleus',
    #     'WII' => 'Nintendo',
    #     'NDS' => 'Nintendo Mobile',
    #     'OS2' => 'OS/2',
    #     'T64' => 'OSF1',
    #     'OBS' => 'OpenBSD',
    #     'PSP' => 'PlayStation Portable',
    #     'PS3' => 'PlayStation',
    #     'RHT' => 'Red Hat',
    #     'ROS' => 'RISC OS',
    #     'REM' => 'Remix OS',
    #     'RZD' => 'RazoDroiD',
    #     'SAB' => 'Sabayon',
    #     'SSE' => 'SUSE',
    #     'SAF' => 'Sailfish OS',
    #     'SLW' => 'Slackware',
    #     'SOS' => 'Solaris',
    #     'SYL' => 'Syllable',
    #     'SYM' => 'Symbian',
    #     'SYS' => 'Symbian OS',
    #     'S40' => 'Symbian OS Series 40',
    #     'S60' => 'Symbian OS Series 60',
    #     'SY3' => 'Symbian^3',
    #     'TDX' => 'ThreadX',
    #     'TIZ' => 'Tizen',
    #     'UBT' => 'Ubuntu',
    #     'WTV' => 'WebTV',
    #     'WIN' => 'Windows',
    #     'WCE' => 'Windows CE',
    #     'WMO' => 'Windows Mobile',
    #     'WPH' => 'Windows Phone',
    #     'WRT' => 'Windows RT',
    #     'XBX' => 'Xbox',
    #     'XBT' => 'Xubuntu',
    #     'YNS' => 'YunOs',
    #     'IOS' => 'iOS',
    #     'POS' => 'palmOS',
    #     'WOS' => 'webOS'
    #    }

    #DOWNCASED_OPERATING_SYSTEMS = OPERATING_SYSTEMS.each_with_object({}){|(short,long),h| h[long.downcase] = short}
    DOWNCASED_OPERATING_SYSTEMS = {"aix"=>"AIX", "android"=>"AND", "amigaos"=>"AMG", "apple tv"=>"ATV", "arch linux"=>"ARL", "backtrack"=>"BTR", "bada"=>"SBA", "beos"=>"BEO", "blackberry os"=>"BLB", "blackberry tablet os"=>"QNX", "brew"=>"BMP", "centos"=>"CES", "chrome os"=>"COS", "cyanogenmod"=>"CYN", "debian"=>"DEB", "dragonfly"=>"DFB", "fedora"=>"FED", "firefox os"=>"FOS", "freebsd"=>"BSD", "gentoo"=>"GNT", "google tv"=>"GTV", "hp-ux"=>"HPX", "haiku os"=>"HAI", "irix"=>"IRI", "inferno"=>"INF", "knoppix"=>"KNO", "kubuntu"=>"KBT", "gnu/linux"=>"LIN", "lubuntu"=>"LBT", "vectorlinux"=>"VLN", "mac"=>"MAC", "maemo"=>"MAE", "mandriva"=>"MDR", "meego"=>"SMG", "mocordroid"=>"MCD", "mint"=>"MIN", "mildwild"=>"MLD", "morphos"=>"MOR", "netbsd"=>"NBS", "mtk / nucleus"=>"MTK", "nintendo"=>"WII", "nintendo mobile"=>"NDS", "os/2"=>"OS2", "osf1"=>"T64", "openbsd"=>"OBS", "playstation portable"=>"PSP", "playstation"=>"PS3", "red hat"=>"RHT", "risc os"=>"ROS", "remix os"=>"REM", "razodroid"=>"RZD", "sabayon"=>"SAB", "suse"=>"SSE", "sailfish os"=>"SAF", "slackware"=>"SLW", "solaris"=>"SOS", "syllable"=>"SYL", "symbian"=>"SYM", "symbian os"=>"SYS", "symbian os series 40"=>"S40", "symbian os series 60"=>"S60", "symbian^3"=>"SY3", "threadx"=>"TDX", "tizen"=>"TIZ", "ubuntu"=>"UBT", "webtv"=>"WTV", "windows"=>"WIN", "windows ce"=>"WCE", "windows mobile"=>"WMO", "windows phone"=>"WPH", "windows rt"=>"WRT", "xbox"=>"XBX", "xubuntu"=>"XBT", "yunos"=>"YNS", "ios"=>"IOS", "palmos"=>"POS", "webos"=>"WOS"}


    # OS_FAMILIES = {
    #     'Android'               => ['AND', 'CYN', 'REM', 'RZD', 'MLD', 'MCD', 'YNS'],
    #     'AmigaOS'               => ['AMG', 'MOR'],
    #     'Apple TV'              => ['ATV'],
    #     'BlackBerry'            => ['BLB', 'QNX'],
    #     'Brew'                  => ['BMP'],
    #     'BeOS'                  => ['BEO', 'HAI'],
    #     'Chrome OS'             => ['COS'],
    #     'Firefox OS'            => ['FOS'],
    #     'Gaming Console'        => ['WII', 'PS3'],
    #     'Google TV'             => ['GTV'],
    #     'IBM'                   => ['OS2'],
    #     'iOS'                   => ['IOS'],
    #     'RISC OS'               => ['ROS'],
    #     'GNU/Linux'             => ['LIN', 'ARL', 'DEB', 'KNO', 'MIN', 'UBT', 'KBT', 'XBT', 'LBT', 'FED', 'RHT', 'VLN', 'MDR', 'GNT', 'SAB', 'SLW', 'SSE', 'CES', 'BTR', 'SAF'],
    #     'Mac'                   => ['MAC'],
    #     'Mobile Gaming Console' => ['PSP', 'NDS', 'XBX'],
    #     'Real-time OS'          => ['MTK', 'TDX'],
    #     'Other Mobile'          => ['WOS', 'POS', 'SBA', 'TIZ', 'SMG', 'MAE'],
    #     'Symbian'               => ['SYM', 'SYS', 'SY3', 'S60', 'S40'],
    #     'Unix'                  => ['SOS', 'AIX', 'HPX', 'BSD', 'NBS', 'OBS', 'DFB', 'SYL', 'IRI', 'T64', 'INF'],
    #     'WebTV'                 => ['WTV'],
    #     'Windows'               => ['WIN'],
    #     'Windows Mobile'        => ['WPH', 'WMO', 'WCE', 'WRT']
    # }

    # FAMILY_TO_OS = OS_FAMILIES.each_with_object({}) do |(family,oss),h|
    #   oss.each{|os| h[os] = family}
    # end

    ## Not calculated just have it!
    FAMILY_TO_OS = {"AND"=>"Android", "CYN"=>"Android", "REM"=>"Android", "RZD"=>"Android", "MLD"=>"Android", "MCD"=>"Android", "YNS"=>"Android", "AMG"=>"AmigaOS", "MOR"=>"AmigaOS", "ATV"=>"Apple TV", "BLB"=>"BlackBerry", "QNX"=>"BlackBerry", "BMP"=>"Brew", "BEO"=>"BeOS", "HAI"=>"BeOS", "COS"=>"Chrome OS", "FOS"=>"Firefox OS", "WII"=>"Gaming Console", "PS3"=>"Gaming Console", "GTV"=>"Google TV", "OS2"=>"IBM", "IOS"=>"iOS", "ROS"=>"RISC OS", "LIN"=>"GNU/Linux", "ARL"=>"GNU/Linux", "DEB"=>"GNU/Linux", "KNO"=>"GNU/Linux", "MIN"=>"GNU/Linux", "UBT"=>"GNU/Linux", "KBT"=>"GNU/Linux", "XBT"=>"GNU/Linux", "LBT"=>"GNU/Linux", "FED"=>"GNU/Linux", "RHT"=>"GNU/Linux", "VLN"=>"GNU/Linux", "MDR"=>"GNU/Linux", "GNT"=>"GNU/Linux", "SAB"=>"GNU/Linux", "SLW"=>"GNU/Linux", "SSE"=>"GNU/Linux", "CES"=>"GNU/Linux", "BTR"=>"GNU/Linux", "SAF"=>"GNU/Linux", "MAC"=>"Mac", "PSP"=>"Mobile Gaming Console", "NDS"=>"Mobile Gaming Console", "XBX"=>"Mobile Gaming Console", "MTK"=>"Real-time OS", "TDX"=>"Real-time OS", "WOS"=>"Other Mobile", "POS"=>"Other Mobile", "SBA"=>"Other Mobile", "TIZ"=>"Other Mobile", "SMG"=>"Other Mobile", "MAE"=>"Other Mobile", "SYM"=>"Symbian", "SYS"=>"Symbian", "SY3"=>"Symbian", "S60"=>"Symbian", "S40"=>"Symbian", "SOS"=>"Unix", "AIX"=>"Unix", "HPX"=>"Unix", "BSD"=>"Unix", "NBS"=>"Unix", "OBS"=>"Unix", "DFB"=>"Unix", "SYL"=>"Unix", "IRI"=>"Unix", "T64"=>"Unix", "INF"=>"Unix", "WTV"=>"WebTV", "WIN"=>"Windows", "WPH"=>"Windows Mobile", "WMO"=>"Windows Mobile", "WCE"=>"Windows Mobile", "WRT"=>"Windows Mobile"} 

    def filenames
      ['oss.yml'.freeze]
    end

  end

end
