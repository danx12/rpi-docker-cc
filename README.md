# Dockerfile to cross-compile kernel modules for Raspberry Pi
Easier and faster than a VM. I was specifically interested on cross-compiling reloadable kernel modules. 

----

## Set-up
1. Clone repository.
```
git clone https://github.com/danx12/rpi-docker-cc
cd rpi-docker-cc
```
2. Obtain the build configuration from the Raspberry pi.
```
# (On the raspberry pi)
sudo modprobe configs

# (On your laptop)
sudo scp pi@ipaddress:/proc/config.gz ./
```
3. Obtain the kernel hash.
```
# (On the raspberry pi)
FIRMWARE_HASH=$(zgrep "* firmware as of" /usr/share/doc/raspberrypi-bootloader/changelog.Debian.gz | head -1 | awk '{ print $5 }')
KERNEL_HASH=$(wget https://raw.github.com/raspberrypi/firmware/$FIRMWARE_HASH/extra/git_hash -O -)
echo $KERNEL_HASH

```
Copy the outputed hash and run:
```
# (On your laptop)
echo <PASTE KERNEL HASH HERE> >> hash.txt
```

4. Build Docker image
```
docker build -t rpi-cc .
```
The building process will take a while, the raspberry pi kernel will be downloaded, primed and compiled.

----
## Usage
Change to directory containing your source files and Makefile. To make the kernel module run.
```
docker run --rm -it -v $PWD:/src rpi-cc
```
It is possible to also run `make clean`
```
docker run --rm -it -v $PWD:/src rpi-cc make clean
```
Or `bash` to do some other stuff in the container.
```
docker run --rm -it -v $PWD:/src rpi-cc bash
```