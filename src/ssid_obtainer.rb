class SSIDObtainer
    def self.obtain
       `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep -E "[^B]SSID:"`.gsub('SSID:', '').strip
    end
end
