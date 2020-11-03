#!/bin/bash
set -x

wget --continue http://buildbot.libretro.com/stable/1.9.0/apple/osx/x86_64/RetroArch.dmg
7z x RetroArch.dmg -onet-ra
mv net-ra/RetroArch/RetroArch.app/* net-ra
mv net-ra/Contents/Resources/assets/xmb/monochrome/png png
rm -rf net-ra/RetroArch net-ra/Contents/Resources/assets/glui net-ra/Contents/Resources/assets/nxrgui net-ra/Contents/Resources/assets/rgui net-ra/Contents/Resources/assets/switch net-ra/Contents/Resources/assets/xmb net-ra/Contents/Resources/database net-ra/Contents/Resources/overlays net-ra/Contents/Resources/shaders
mkdir -p net-ra/Contents/Resources/assets/xmb/monochrome
mv png net-ra/Contents/Resources/assets/xmb/monochrome
cp -r os/mac/autoconfig/* net-ra/Contents/Resources/autoconfig
cp -r config system required.cfg default.cfg version.txt net-ra
chmod 700 net-ra/Contents/MacOS/RetroArch
cp os/mac/cmd/* net-ra

mkdir net-ra/roms net-ra/cores net-ra/filters net-ra/filters/audio net-ra/downloads net-ra/logs

curl -L http://buildbot.libretro.com/nightly/apple/osx/x86_64/latest/nestopia_libretro.dylib.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/apple/osx/x86_64/latest/picodrive_libretro.dylib.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/apple/osx/x86_64/latest/snes9x_libretro.dylib.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/apple/osx/x86_64/latest/fbneo_libretro.dylib.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/apple/osx/x86_64/latest/mednafen_saturn_libretro.dylib.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip

rm dist/net-ra.mac
7z a -sfxos/mac/7z.sfx dist/net-ra.mac net-ra
chmod 700 dist/net-ra.mac

rm -rf net-ra
#rm RetroArch.dmg
