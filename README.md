# mkclashrule
bash script for generating rules for the open-source version of Clash core (not premium).

## Description
I'm a long-time user of [Clash](https://github.com/Dreamacro/clash) the transparent proxy, and I have to update my Clash rules recently. Unfortunately, I couldn't find a working rule config for the open-source version of Clash core; almost all the websites out there and the repositories on GitHub only provide `RULE-SET`s for the [Premium version](https://github.com/Dreamacro/clash/releases/tag/premium) of Clash. Apart from being proprietary, this subscription-based rule maientance model doesn't work for me due to some weird network issues. Furious, I decided to write my own script for generating such a config.

The rules are based on [Loyalsoldier/clash-rules](https://github.com/Loyalsoldier/clash-rules), thus this script is based on their [GitHub Actions workflow](https://github.com/Loyalsoldier/clash-rules/blob/master/.github/workflows/run.yml). Here, I only incorporated certain rule sets of theirs which fit my needs, namely:
```
# yes, this is taken directly from the said workflow

Loyalsoldier_direct=https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt
Loyalsoldier_proxy=https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt
felixonmars_apple=https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf
custom_private=https://raw.githubusercontent.com/Loyalsoldier/domain-list-custom/release/private.txt
cn_cidr=https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/cn.txt
lan_cidr=https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/private.txt
telegram_cidr=https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/telegram.txt
```
Feel free to edit the script yourself and add more sources on your own; It's really not that hard.
## Usage
dependencies: `curl perl`

`bash <(curl -Ls https://raw.githubusercontent.com/aisuneko/mkclashrule/master/mkclashrule.sh)`

This would generate a `rules.yaml` file which stores the rules config under your cwd.
After that, you can use its content to replace the original `rules:` section in your Clash config file. 
