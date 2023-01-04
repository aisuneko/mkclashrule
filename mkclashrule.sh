#!/bin/bash

# whitelist mode

# Loyalsoldier_gfw=https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt
# Loyalsoldier_greatfire=https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/greatfire.txt
Loyalsoldier_direct=https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt
Loyalsoldier_proxy=https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt
felixonmars_apple=https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf
custom_private=https://raw.githubusercontent.com/Loyalsoldier/domain-list-custom/release/private.txt
cn_cidr=https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/cn.txt
lan_cidr=https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/private.txt
telegram_cidr=https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/telegram.txt

export proxy_alias="auto"

echo "rules:" > rules.yaml

curl -sSL ${Loyalsoldier_direct} | grep -Ev "^(regexp|keyword):" | perl -ne '/^(full:)([-_a-zA-Z0-9]+(\.[-_a-zA-Z0-9]+)*)/ && print "  - DOMAIN,$2,DIRECT\n"' >> rules.yaml
curl -sSL ${Loyalsoldier_direct} | grep -Ev "^(regexp|keyword|full):" | perl -ne '/^(domain:)?([-_a-zA-Z0-9]+(\.[-_a-zA-Z0-9]+)*)/ && print "  - DOMAIN,$2,DIRECT\n"' >> rules.yaml

curl -sSL ${Loyalsoldier_proxy} | grep -Ev "^(regexp|keyword):" | perl -ne '/^(full:)([-_a-zA-Z0-9]+(\.[-_a-zA-Z0-9]+)*)/ && print "  - DOMAIN,$2,$ENV{proxy_alias}\n"' >> rules.yaml
curl -sSL ${Loyalsoldier_proxy} | grep -Ev "^(regexp|keyword|full):" | perl -ne '/^(domain:)?([-_a-zA-Z0-9]+(\.[-_a-zA-Z0-9]+)*)/ && print "  - DOMAIN,$2,$ENV{proxy_alias}\n"' >> rules.yaml

# curl -sSL ${Loyalsoldier_gfw} | grep -Ev "^(regexp|keyword):" | perl -ne '/^(domain:|full:)?([-_a-zA-Z0-9]+(\.[-_a-zA-Z0-9]+)*)/ && print "  - DOMAIN,$2,$ENV{proxy_alias}\n"' >> rules.yaml
# curl -sSL ${Loyalsoldier_greatfire} | grep -Ev "^(regexp|keyword):" | perl -ne '/^(domain:|full:)?([-_a-zA-Z0-9]+(\.[-_a-zA-Z0-9]+)*)/ && print "  - DOMAIN,$2,$ENV{proxy_alias}\n"' >> rules.yaml

curl -sSL ${felixonmars_apple} | perl -ne '/^server=\/([^\/]+)\// && print "  - DOMAIN,+.$1,DIRECT\n"' >> rules.yaml

curl -sSL ${custom_private} | awk -F ':' '/^full:/ {printf "  - DOMAIN,%s,DIRECT\n", $2}' >> rules.yaml
curl -sSL ${custom_private} | awk -F ':' '/^domain:/ {printf "  - DOMAIN,+.%s,DIRECT\n", $2}' >> rules.yaml

curl -sSL ${lan_cidr} | grep -Ev "::" | perl -ne '/(.+\/\d+)/ && print "  - IP-CIDR,$1,DIRECT\n"'  >> rules.yaml
curl -sSL ${lan_cidr} | grep -E "::" | perl -ne '/(.+\/\d+)/ && print "  - IP-CIDR6,$1,DIRECT\n"'  >> rules.yaml

curl -sSL ${cn_cidr} | grep -Ev "::" | perl -ne '/(.+\/\d+)/ && print "  - IP-CIDR,$1,DIRECT\n"'  >> rules.yaml
curl -sSL ${cn_cidr} | grep -E "::" | perl -ne '/(.+\/\d+)/ && print "  - IP-CIDR6,$1,DIRECT\n"'  >> rules.yaml

curl -sSL ${telegram_cidr} | grep -Ev "::" | perl -ne '/(.+\/\d+)/ && print "  - IP-CIDR,$1,$ENV{proxy_alias}\n"'  >> rules.yaml
curl -sSL ${telegram_cidr} | grep -E "::" | perl -ne '/(.+\/\d+)/ && print "  - IP-CIDR6,$1,$ENV{proxy_alias}\n"'  >> rules.yaml

echo "  - GEOIP,LAN,DIRECT" >> rules.yaml
echo "  - GEOIP,CN,DIRECT" >> rules.yaml
echo "  - MATCH,$proxy_alias" >> rules.yaml

unset proxy_alias
