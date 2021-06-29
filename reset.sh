#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OCFBASEPATH=`jq --raw-output '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json`

# TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq --raw-output '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json`

if [ "$PLATFORM" == "esp32" ]; then
  #MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  #eval ${MY_COMMAND}
  MY_COMMAND="cd ${CURPWD}/src"
  eval ${MY_COMMAND}
  MY_COMMAND="idf.py -p /dev/ttyUSB0 erase_flash"
  eval ${MY_COMMAND}
  #cd $CURPWD
elif [ "$PLATFORM" == "arduino" ]; then
  echo "Arduino reset"
elif [ "$OCFSUBPATH" == "/iot" ]; then
  rm -f ./bin/server_security.dat
  MY_COMMAND="cp ${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ./bin/server_security.dat"
  eval ${MY_COMMAND}
elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  rm -rf ./bin/device_builder_server_creds
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi
