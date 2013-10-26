class SSIDObtainer
    def self.current_ssid
       `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep -E "[^B]SSID:"`.gsub('SSID:', '').strip
    end
end
