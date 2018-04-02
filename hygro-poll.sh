#!/bin/bash
#----------------------------------------------
mqttbroker="localhost"
blemacs="4C:65:A8:D0:43:35"
cmdprefix="Notification handle = 0x000e value:"
tempprefix="T="
topicprefix="tele/hygrometer-"
#----------------------------------------------
for c in $blemacs; do
  echo -n "Querying Hygrometer $c..."
  cmd=$(/usr/bin/gatttool -b $c --char-write-req --handle=0x0010 --value=0100 --listen | grep  --max-count=1 "Notification handle")
  # Uncomment for Debuging puropses and comment the line above
  #cmd="Notification handle = 0x000e value: 54 3d 32 30 2e 30 20 48 3d 33 31 2e 32 00"
  if [ -z "$cmd" ]; then
    echo "Error Querying $c"
  else
    echo -n "OK - Response: "
    cmd=${cmd#$cmdprefix}
    cmd=$(echo "0x"$cmd | sed -e 's/ / 0x/g')
    for x in $cmd; do
      hextoascii=$(echo $x | xxd -r)
      parsedout=$parsedout$hextoascii
    done
     stripedtemp=${parsedout#$tempprefix}
    stripedblemac=$(echo ${blemacs: -5} | tr -d :)
    echo -n "Publishing MQTT Topics: "
    bash -c '/usr/bin/mosquitto_pub --host '$mqttbroker' --topic '$topicprefix$stripedblemac'/TEMP --message '${stripedtemp%H*}
    echo -n "Temp: "${stripedtemp%H*}
    stripedhumi=$( echo $parsedout | cut -d'H' -f2 | cut -d'=' -f2)
    bash -c '/usr/bin/mosquitto_pub --host '$mqttbroker' --topic '$topicprefix$stripedblemac'/HUMI --message '${stripedhumi}
    echo " / Humi: "${stripedhumi}
  fi
done

