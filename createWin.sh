#!/bin/bash
set -x

wget --continue http://buildbot.libretro.com/stable/1.9.0/windows/x86_64/RetroArch.7z
# wget --continue http://buildbot.libretro.com/stable/1.9.0/windows-msvc2010/x86/RetroArch.7z
7z x RetroArch.7z -onet-ra
mv net-ra/assets/xmb/monochrome/png png
mv net-ra/libbz2-1.dll net-ra/libfreetype-6.dll net-ra/libgcc_s_seh-1.dll net-ra/libglib-2.0-0.dll net-ra/libgraphite2.dll net-ra/libharfbuzz-0.dll net-ra/libiconv-2.dll net-ra/libintl-8.dll net-ra/libpcre-1.dll net-ra/libpng16-16.dll net-ra/libstdc++-6.dll net-ra/libwinpthread-1.dll net-ra/zlib1.dll .
rm -rf net-ra/assets/glui net-ra/assets/nxrgui net-ra/assets/rgui net-ra/assets/switch net-ra/assets/xmb net-ra/database net-ra/overlays net-ra/shaders net-ra/platforms net-ra/*.exe net-ra/*.dll net-ra/bearer net-ra/iconengines net-ra/imageformats net-ra/styles 
mkdir -p net-ra/assets/xmb/monochrome
mv png net-ra/assets/xmb/monochrome
cp -r os/win/autoconfig/* net-ra/autoconfig
cp -r config system required.cfg default.cfg version.txt os/win/compiled/* os/win/cmd/* net-ra
mv *.dll net-ra

mkdir net-ra/roms net-ra/cores

curl -L http://buildbot.libretro.com/nightly/windows/x86_64/latest/nestopia_libretro.dll.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/windows/x86_64/latest/picodrive_libretro.dll.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/windows/x86_64/latest/snes9x_libretro.dll.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/windows/x86_64/latest/fbneo_libretro.dll.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip
curl -L http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_saturn_libretro.dll.zip -o temp.zip; unzip temp.zip -d net-ra/cores; rm temp.zip

cat os/win/default.cfg >> net-ra/default.cfg

rm dist/net-ra.exe
7z a -sfxos/win/7z.sfx dist/net-ra.exe net-ra

rm -rf net-ra
#rm RetroArch.7z
