# raspberry pi nix image

## build

Build with `nix run` (image will be located in `./result/sd-image`)

## flash

```sh 
DEVICE=/dev/sdx
sudo dd bs=4096 conv=fsync status=progress of=$DEVICE if=result/sd-image/*.img
```

## connect to raspi over direct ethernet

https://unix.stackexchange.com/questions/295238/how-to-connect-to-device-via-ssh-over-direct-ethernet-connection

```sh
IFACE=eth2
sudo ifconfig $IFACE 192.168.9.1
sudo dnsmasq -d -C /dev/null --port=0 --domain=localdomain --dhcp-range=192.168.9.2,192.168.9.10,99h --interface=$IFACE
sudo tcpdump -i $IFACE
```
