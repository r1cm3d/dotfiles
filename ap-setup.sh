#!/bin/sh
# ap-setup.sh - M5 como AP 'burro': casa (VLAN 30 untagged) + convidados (VLAN 50 tagged)
set -e

HOSTNAME='ap-office'
UPLINK='lan'                # porta mais distante da fonte; confira em /etc/board.json
MGMT_IP='192.168.30.11'     # IP fixo na VLAN 30, fora do pool DHCP
MGMT_MASK='255.255.255.0'
MGMT_GW='192.168.30.1'
GUEST_VID='50'
CHAN_5G='36'
SSID_HOME='lm41'
KEY_HOME='CHANGE_ME'
ENC_HOME='psk2+ccmp'        # use 'sae-mixed' se o Deco hoje usa WPA2/WPA3
SSID_GUEST='lm41-gu3st'
KEY_GUEST='CHANGE_ME'

# --- sistema
uci set system.@system[0].hostname="$HOSTNAME"
uci set system.@system[0].zonename='America/Sao Paulo'
uci set system.@system[0].timezone='<-03>3'
uci commit system

# --- rede
cat > /etc/config/network <<EOF
config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports '$UPLINK'

config device
	option name 'br-guest'
	option type 'bridge'
	list ports '$UPLINK.$GUEST_VID'
	option ipv6 '0'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '$MGMT_IP'
	option netmask '$MGMT_MASK'
	option gateway '$MGMT_GW'
	list dns '$MGMT_GW'

config interface 'guest'
	option device 'br-guest'
	option proto 'none'
EOF

# --- firewall do próprio AP (o tráfego em bridge não passa por ele)
cat > /etc/config/firewall <<'EOF'
config defaults
	option input 'REJECT'
	option output 'ACCEPT'
	option forward 'REJECT'
	option synflood_protect '1'

config zone
	option name 'lan'
	list network 'lan'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'REJECT'

config zone
	option name 'guest'
	list network 'guest'
	list device 'br-guest'
	option input 'DROP'
	option output 'ACCEPT'
	option forward 'REJECT'
EOF

# --- wireless: acha os rádios pela banda
R2=''; R5=''
for r in $(uci show wireless | sed -n 's/^wireless\.\([^.=]*\)=wifi-device$/\1/p'); do
  case "$(uci -q get wireless.$r.band)" in
    2g) R2=$r ;;
    5g) R5=$r ;;
  esac
done
if [ -z "$R5" ]; then echo 'radio 5 GHz nao encontrado'; exit 1; fi

while uci -q delete wireless.@wifi-iface[0]; do :; done

if [ -n "$R2" ]; then uci set wireless.$R2.disabled='1'; fi
uci set wireless.$R5.disabled='0'
uci set wireless.$R5.country='BR'
uci set wireless.$R5.channel="$CHAN_5G"
uci set wireless.$R5.htmode='VHT80'

uci set wireless.home=wifi-iface
uci set wireless.home.device="$R5"
uci set wireless.home.mode='ap'
uci set wireless.home.network='lan'
uci set wireless.home.ifname='wl-home'
uci set wireless.home.ssid="$SSID_HOME"
uci set wireless.home.encryption="$ENC_HOME"
uci set wireless.home.key="$KEY_HOME"

uci set wireless.guest=wifi-iface
uci set wireless.guest.device="$R5"
uci set wireless.guest.mode='ap'
uci set wireless.guest.network='guest'
uci set wireless.guest.ifname='wl-guest'
uci set wireless.guest.ssid="$SSID_GUEST"
uci set wireless.guest.encryption='psk2+ccmp'
uci set wireless.guest.key="$KEY_GUEST"
uci set wireless.guest.isolate='1'
uci commit wireless

# --- servicos de roteador desligados
for s in dnsmasq odhcpd; do
  if [ -x /etc/init.d/$s ]; then /etc/init.d/$s disable; fi
done
/etc/init.d/firewall enable

echo "OK: $HOSTNAME configurado. Rode 'reboot' e mova o cabo para a porta de bancada."
