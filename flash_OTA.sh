#!/bin/bash
# 配置环境
Packages(){
myLinux=''
if grep -Eqii "Arch Linux" /etc/issue || grep -Eq "Arch Linux" /etc/*-release; then
myLinux=1
sudo pacman -S wget python python-protobuf android-tools
else
myLinux=0
sudo apt-get install wget python python-protobuf android-tools-fastboot
fi
}
# 检查设备
CheckDevice(){
fastboot $* getvar product 2>&1 | grep "^product: *alioth"
if [ $? -ne 0  ] ; then echo -e "\n\n\n\n\n\n\n\n\t\t请插入正确的设备\n\n\n\n\n\n\n\n"; exit 1; fi
}
# 准备刷机包
PrePare(){
git clone https://gitee.com/baizhi958216/lineage-os_scripts.git --depth=1
if [ ! -d lineage-os_scripts ];then
  git clone https://github.com/LineageOS/scripts.git lineage-os_scripts --depth=1
fi
wget -O alioth.zip https://hugeota.d.miui.com/21.9.17/miui_ALIOTH_21.9.17_25b8385d90_11.0.zip
unzip alioth.zip payload.bin
python lineage-os_scripts/update-payload-extractor/extract.py payload.bin --output_dir ./out
}
# 刷机
Flash(){
cd ./out
echo -e "\n\n\n\n\n\n\n\n\t\t5秒后开始刷入，请勿挪动数据线或设备\n\n\n\n\n\n\n\n"
sleep 5
fastboot flash abl_ab abl.img
fastboot flash aop_ab aop.img
fastboot flash bluetooth_ab bluetooth.img
fastboot flash boot_ab boot.img
fastboot flash cmnlib64_ab cmnlib64.img
fastboot flash cmnlib_ab cmnlib.img
fastboot flash devcfg_ab devcfg.img
fastboot flash dsp_ab dsp.img
fastboot flash dtbo_ab dtbo.img
fastboot flash featenabler_ab featenabler.img
fastboot flash hyp_ab hyp.img
fastboot flash imagefv_ab imagefv.img
fastboot flash keymaster_ab keymaster.img
fastboot flash modem_ab modem.img
fastboot flash qupfw_ab qupfw.img
fastboot flash tz_ab tz.img
fastboot flash uefisecapp_ab uefisecapp.img
fastboot flash vbmeta_ab vbmeta.img
fastboot flash vbmeta_system_ab vbmeta_system.img
fastboot flash vendor_boot_ab vendor_boot.img
fastboot flash xbl_config_ab xbl_config.img
fastboot flash xbl_ab xbl.img
echo -e "\n\n\n\n\n\n\n\n\t\t重启进入fastbootd\n\n\n\n\n\n\n\n"
fastboot reboot fastboot
fastboot flash vendor vendor.img
fastboot flash system_ext system_ext.img
fastboot flash system system.img
fastboot flash product product.img
fastboot flash odm odm.img
fastboot set_active b
fastboot reboot
}
Packages
CheckDevice
PrePare
Flash
