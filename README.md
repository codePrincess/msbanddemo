# MSBandDemo

This project shall help you getting started with fetching data from the various sensors from the MSBand with iOS. The demo was coded with a MSBand 2 and connects to the majority of the available sensors.

## SDKs and Sensor Documentation
The SDKs for iOS, Android and Windows can be downloaded here: https://developer.microsoftband.com/bandSDK.
The detailed documentation on the different sensor values can be look up here: https://developer.microsoftband.com/Content/docs/Microsoft%20Band%20SDK.pdf

## Getting started
Download the "Microsoft Health" app from the app store to easily pair the Band with your iOS device. After this is done the demo should work out of the box :)

## Sensor coverage
The app covers data retrieval from the following sensors in the MS Band 2.
 - Altimeter
 - Calories
 - GRS
 - SkinTemperature
 - Pedometer
 - HeartRate
 - Distance
 - UV (Light Index)
 - Barometer
 - Contact

Not covered in this demo:
 - Accelerometer
 - AmbientLight
 - Gyroscope
 - RRInterval

For getting values of the sensors, which are not covered in the demo app, you can easily use the same mechanism which was used for the upper covered sensors.

### Subscribe to data retrieval for a specific sensor

    func startBarometerSensor() {
        do {
            try connectedClient?.sensorManager.startBarometerUpdatesToQueue(nil,
            withHandler: { (data, error) in
                //do something awesome with the data you just got from the sensor
            })
        } catch {
            //handle the error - there was a problem during data retrieval from the sensor
        }
    }

## Important facts and numbers
The demo was written with Swift in Xcode 7.3. There is (sadly) no guarantee that the project will smoothly compile and run on future Xcode versions because of the fixed IDE<->Compiler version binding. But the good news is: mostly there are just some mini tweaks to do that the app compiles and runs again.

## Credits
All used icons are made by http://www.freepik.com from http://www.flaticon.com" which is licensed by Creative Commons 3.0 BY

## Contact
If anything goes completely crazy and you need help, just contact me on Twitter @codeprincess. I will try to react in a reasonable delay of time :D
