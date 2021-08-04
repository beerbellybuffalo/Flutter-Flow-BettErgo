#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h> 
#include <BLE2902.h>
#define SERVICE_UUID        "ac78dae7-fe7f-45fa-8b4b-a553aba82693"
#define CHARACTERISTIC1_UUID "4cee02fe-dc6f-4a6a-b8fa-789d79058177"
#define CHARACTERISTIC2_UUID "c53e7632-9a2b-4272-b1a8-d2f4d658752a" //send values to this one, either 1 or 2.
int fsr1 = 34;
int fsr2 = 35; 
int fsr3 = 32; 
int fsr4 = 33;
int fsr5 = 25; 
int fsr6 = 26; 
int fsr7 = 27;
int fsr8 = 14;
int fsr9 = 12;
int fsr10 = 4;
int fsr11 = 16;
int vibmot = 2;

bool deviceConnected = false;
bool oldDeviceConnected = false;
int period = 1000;
int vibperiod1 = 1000;
int vibperiod2 = 3000;
unsigned long time_1= 0;
unsigned long time_2 = 0;
unsigned long time_3 = 0;
int vibmotoract =0;
int vib1state = 0;
int vib2state = 0;
int lastvib1state = 0;
int lastvib2state = 0;
String collate = "";
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic1 = NULL;
BLECharacteristic* pCharacteristic2 = NULL;

String checkReading (int pin) {
    float reading = analogRead(pin);
    char txString[8];
    dtostrf(reading,1,2, txString);
  //Serial.print(reading);
  //Serial.print(", ");
    return txString;
    }
;
class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };
    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};


void setup() {
  Serial.begin(115200);   // We'll send debugging information via the Serial monitor

  pinMode(fsr1, INPUT);  
  pinMode(fsr2, INPUT);  
  pinMode(fsr3, INPUT);  
  pinMode(fsr4, INPUT);
  pinMode(fsr5, INPUT);  
  pinMode(fsr6, INPUT); 
  pinMode(fsr7, INPUT);
  pinMode(fsr8, INPUT);
  pinMode(fsr9, INPUT);
  pinMode(fsr10, INPUT);
  pinMode(fsr11, INPUT);
  pinMode(vibmot, OUTPUT);
  
  

  Serial.println("Starting BLE work!");
  BLEDevice::init("BetterSittTESTING");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic1 = pService->createCharacteristic(
                                         CHARACTERISTIC1_UUID,
                                         BLECharacteristic::PROPERTY_READ   |
                                         BLECharacteristic::PROPERTY_NOTIFY |
                                         BLECharacteristic::PROPERTY_INDICATE
                                       );
  pCharacteristic2 = pService->createCharacteristic(
                                       CHARACTERISTIC2_UUID,
                                       BLECharacteristic::PROPERTY_READ |
                                       BLECharacteristic::PROPERTY_WRITE |
                                       BLECharacteristic::PROPERTY_NOTIFY |
                                       BLECharacteristic::PROPERTY_INDICATE
                                     );
  pCharacteristic1->addDescriptor(new BLE2902());
  pCharacteristic2->addDescriptor(new BLE2902());
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  pCharacteristic1->setValue("Initialising");
  pCharacteristic1->notify();
  pCharacteristic2->setValue("0");
  pCharacteristic2->notify();
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");
}

void loop(void) {
    
    if (deviceConnected) {
      if(millis() >= time_1 + period){
        time_1 += period;
        //collate = "7, 6, 69, 26, 757, 731, 252, 0, 10";
        collate = checkReading(fsr1)+","+checkReading(fsr2)+","+checkReading(fsr3)+","+checkReading(fsr4)+","+checkReading(fsr5)+","+checkReading(fsr6)+","+checkReading(fsr7)+","+checkReading(fsr8)+","+checkReading(fsr9)+","+checkReading(fsr10)+","+checkReading(fsr11);
        pCharacteristic1->setValue(collate.c_str());
        pCharacteristic1->notify();
        Serial.println(" ***");}
        
     std::string rxValue = pCharacteristic2->getValue();
     rxValue = rxValue.c_str();
     if (rxValue == "1"){
      vib1state = 1;
      if(lastvib1state != vib1state){
      Serial.print("*** VIBRATE BITCH 1 SEC ***");
        time_2 = millis();
        lastvib1state = vib1state;}
      vibmotoract = 1;
      digitalWrite(vibmot, HIGH);
      
     }
     if (rxValue == "2"){
      vib2state = 1;
      if(lastvib2state != vib2state){
      Serial.print("*** VIBRATE BITCH 3 SEC ***");
        time_3 = millis();}
      vibmotoract = 2;
      digitalWrite(vibmot, HIGH);
      lastvib2state = vib2state; 

     if (rxValue == "0"){
      digitalWrite(vibmot, LOW);
      vib1state = 0;
      lastvib1state = 0;
      vib2state = 0;
      lastvib2state = 0;
      vibmotoract = 0;
        }
     }
     if((millis() - time_2) >= vibperiod1 && vibmotoract == 1){
      digitalWrite(vibmot, LOW);
      pCharacteristic2->setValue("0");
      pCharacteristic2->notify();
      vib1state = 0;
      lastvib1state = 0;
      vibmotoract = 0;
      }
     if((millis() - time_3) >= vibperiod2 && vibmotoract == 2){
      digitalWrite(vibmot, LOW);
      pCharacteristic2->setValue("0");
      pCharacteristic2->notify();
      vib2state = 0;
      lastvib2state = 0;
      vibmotoract = 0;
      }

    
      //Serial.print("*** Sent Value: ");
      //Serial.print(collate);
 
      }
    if (!deviceConnected && oldDeviceConnected) {
       delay(500); // give the bluetooth stack the chance to get things ready
       pServer->startAdvertising(); // restart advertising
       Serial.println("start advertising");
       oldDeviceConnected = deviceConnected;
    }
    if (deviceConnected && !oldDeviceConnected) {
        // do stuff here on connecting
       oldDeviceConnected = deviceConnected;
    }
    }
