#!/bin/bash
 
LOCALDIR=`cd "$( dirname ${BASH_SOURCE[0]} )" && pwd`
cd $LOCALDIR
source $LOCALDIR/../bin.sh
source $LOCALDIR/../language_helper.sh

os_type="$1"
systemdir="$TARGETDIR/system/system"
configdir="$TARGETDIR/config"
rom_folder="$LOCALDIR/rom_make_patch/$(echo $os_type | tr "[:upper:]" "[:lower:]")"
vintf_folder="$LOCALDIR/add_etc_vintf_patch/$(echo $os_type | tr "[:upper:]" "[:lower:]")"
debloat_foldir="$LOCALDIR/../apps_clean"
debloat_script="$(echo $os_type | tr "[:upper:]" "[:lower:]").sh"

# add libs
add_libs() {
  local lib_dirs="lib lib64"

  # add libs
  cp -frpn $rom_folder/add_libs/system/* $systemdir
      
  # add libs fs data
  rm -rf $TARGETDIR/add_libs_fs
  mkdir -p $TARGETDIR/add_libs_fs
  
  if [ -f $configdir/system_fs_config ];then
    for lib_arch in $lib_dirs ;do
      [[ ! -d $rom_folder/add_libs/system/$lib_arch ]] || [[ $(cd $rom_folder/add_libs/system/$lib_arch; ls | wc -l; cd $LOCALDIR) = 0 ]] && continue
      for libs in $(ls $rom_folder/add_libs/system/$lib_arch) ;do
        echo "system/system/$lib_arch/$libs 0 0 0644" >> $TARGETDIR/add_libs_fs/${os_type}_add_libs_fs
      done
    done
    cat $TARGETDIR/add_libs_fs/${os_type}_add_libs_fs >> $configdir/system_fs_config
  fi
    
  if [ -f $configdir/system_file_contexts ];then
    for lib_arch in $lib_dirs ;do
       [[ ! -d $rom_folder/add_libs/system/$lib_arch ]] || [[ $(cd $rom_folder/add_libs/system/$lib_arch; ls | wc -l; cd $LOCALDIR) = 0 ]] && continue
      for libs in $(ls $rom_folder/add_libs/system/$lib_arch) ;do
        echo "/system/system/$lib_arch/$(echo $libs | sed -e 's|\.|\\.|g') u:object_r:system_lib_file:s0" >> $TARGETDIR/add_libs_fs/${os_type}_add_libs_contexts
      done
    done
    cat $TARGETDIR/add_libs_fs/${os_type}_add_libs_contexts >> $configdir/system_file_contexts
  fi
}
if [ -d $rom_folder/add_libs/system ];then
  add_libs
fi

# pixel
if [ $os_type = "Pixel" ];then
  # Add oem properites
  #./add_build.sh
  $vintf_folder/add_vintf.sh
  # Fixing ROM Features
  $rom_folder/make.sh
  echo "$DEBLOATING_STR"
  $debloat_foldir/$debloat_script "$systemdir"
  # Not flatten apex
  echo "true" > $TARGETDIR/apex_state
fi

# oxygen
if [ $os_type = "OxygenOS" ];then
  ./add_build.sh > /dev/null 2>&1
  $vintf_folder/h2os/add_vintf.sh > /dev/null 2>&1
  # Fixing ROM Features
  $rom_folder/h2os/make.sh > /dev/null 2>&1
  echo "$DEBLOATING_STR"
  $debloat_folder/h2os.sh "$systemdir" > /dev/null 2>&1
fi

 # flyme
if [ $os_type = "Flyme" ];then
  ./add_build.sh > /dev/null 2>&1
  $vintf_folder/flyme/add_vintf.sh > /dev/null 2>&1
  echo "$DEBLOATING_STR"
  $debloat_folder/flyme.sh "$systemdir" > /dev/null 2>&1
fi

# miui
if [ $os_type = "MIUI" ];then
  ./add_build.sh > /dev/null 2>&1
  .$vintf_folder/miui/add_vintf.sh > /dev/null 2>&1
  # Fixing ROM Features
  $rom_folder/miui/make.sh > /dev/null 2>&1
  echo "$DEBLOATING_STR"
  $debloat_folder/miui.sh "$systemdir" > /dev/null 2>&1
fi

# joy
if [ $os_type = "JoyUI" ];then
  cp -frp $(find ../out/vendor -type f -name 'init.blackshark.rc') $systemdir/etc/init/
  cp -frp $(find ../out/vendor -type f -name 'init.blackshark.common.rc') $systemdir/etc/init/
  echo "/system/system/etc/init/init\.blackshark\.common\.rc u:object_r:system_file:s0" >> ../out/config/system_file_contexts
  echo "/system/system/etc/init/init\.blackshark\.rc u:object_r:system_file:s0" >> ../out/config/system_file_contexts   
  sed -i '/^\s*$/d' ../out/config/system_file_contexts
  echo "system/system/etc/init/init.blackshark.common.rc 0 0 0644" >> ../out/config/system_fs_config
  echo "system/system/etc/init/init.blackshark.rc 0 0 0644" >> ../out/config/system_fs_config
  sed -i '/^\s*$/d' ../out/config/system_fs_config
  echo "$DEBLOATING_STR"
  $debloat_folder/miui.sh "$systemdir" > /dev/null 2>&1
fi

# color
if [ $os_type = "ColorOS" ];then
  ./add_build.sh > /dev/null 2>&1
  $vintf_folder/add_vintf.sh > /dev/null 2>&1
  # Fixing ROM Features
  $rom_folder/color/make.sh > /dev/null 2>&1
  echo "$DEBLOATING_STR"
  $debloat_folder/color.sh "$systemdir" > /dev/null 2>&1
fi

# funtouch
if [ $os_type = "FuntouchOS" ];then
  ./add_build.sh > /dev/null 2>&1
  $vintf_folder/vivo/add_vintf.sh > /dev/null 2>&1
  # Fixing ROM Features
  $rom_folder/vivo/make.sh > /dev/null 2>&1
  echo "$DEBLOATING_STR"
  $debloat_folder/vivo.sh "$systemdir" > /dev/null 2>&1
fi