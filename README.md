# raspberry pi nix image

## build

Build with `nix run` (image will be located in `./result`)

## flash

```sh 
DEVICE=/dev/sdx
sudo dd if=result/image/nixpi.img of=$DEVICE bs=4096 conv=fsync status=progress
```

## connect to raspi over direct ethernet

https://unix.stackexchange.com/questions/295238/how-to-connect-to-device-via-ssh-over-direct-ethernet-connection

```sh
IFACE=eth2
sudo ifconfig $IFACE 192.168.9.1
sudo dnsmasq -d -C /dev/null --port=0 --domain=localdomain --interface=$IFACE --dhcp-range=192.168.9.2,192.168.9.10,99h
```
