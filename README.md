# Android-IOS AI IOT Controll

Due to HTTP-HTTPS communication and sending TCP packets, with this Application you can easily send your Image and Messages to you IOT-Server by sending a request.
This connection is handled as a [FIFO]() connection, single-core processors.

- Image processing is done by [YOLO AI]() model

For using your model you can use [TFlite](https://pub.dev/packages/tflite) Lib.

## Getting Started

#### API's :
-  ShowImage : (GET) -> [IP/showImage?/]()
  
-  Sending Message : (POST) -> [IP/submit/]() _ Form data (inputs:String)

#### Giude :
This Application is based on [MVVM articheture](), for using this app put the IP of your device in the box and wait for the program to check your request after pressing the Connect Button.
Your request will be sent to the following address:
DEVICE_IP_ADDRESS:PORT/submit
If the connection is established, you will go to the Controller page.

The received Photos will be processed by the program of the defined models and the user will be shown information such as the percentage of correct recognition of the model and the position of the object.
for more information you can read TFlite Documents.
