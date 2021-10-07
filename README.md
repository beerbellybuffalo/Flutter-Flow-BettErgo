# BetterSitt
Team members
Kwang Kai Jie (ASD), See Tow Jo Wee (ASD), Emil Goh Pei Peng (EPD), Daniel Tang Ju Qian (EPD), Timothy Stuart Ng Wei Wen (EPD), Wong Yi Xuan (EPD), Yeoh Jia Er (ISTD)


## Problem and Objective
Physiotherapy is the default, and often only available option for back pains that do not require surgical intervention. However, visits can be few and far between when clinics are occupied with treating more injuries, or in the case where patients perceive treatment to be unnecessary or too expensive. Regarding the recovery process, it takes two hands to clap and apart from seeking professional help, building good lifestyle habits is a personal responsibility and indispensable part of upkeeping back health.

Our project aims to make the process of back injury recovery more efficient, as well as encourage lifestyle habits that prevent reoccurrence.


## About the BetterSitt
A personal IoT device for monitoring sitting posture and training, comprising of a hardware (portable seat add-on) and software (Flutter app) component.

This app was built using FlutterFlow and Flutter v2.2, latest release for Android API 30
For more details -> https://capstone2021.sutd.edu.sg/projects/bettersitt


### IMPORTANT regarding Firestore:

For projects with Firestore integration, you must first run the following commands to ensure the project compiles:

```
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

This command creates the generated files that parse each Record from Firestore into a schema object.
