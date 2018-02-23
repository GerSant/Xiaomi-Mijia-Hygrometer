# Xiaomi-Mijia-Hygrometer
Resources for the new Xiaomi Mijia Bluetooth Hygrometer

The hygro-pool.sh bash script is intended to query, in every execution, an array of Hygrometers represented by his Bluetooth MAC Addresses, and wirte the results (Temperature and Humidity) in separate MQTT Topcis.

I need help with the Battery Status decrypt messages, acctually my device respond with 

```
0xfd 0x44 0xec 0x1f 0x31 0x6f
```

That respresents the battery is in excelent state
