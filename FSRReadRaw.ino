#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h> 
#include <BLE2902.h>
#define SERVICE_UUID        "ac78dae7-fe7f-45fa-8b4b-a553aba82693"
#define CHARACTERISTIC_UUID "4cee02fe-dc6f-4a6a-b8fa-789d79058177"
int fsr1 =34;
int fsr2 = 35; 
int fsr3 = 32; 
int fsr4 = 33;
int fsr5 = 25; 
int fsr6 = 26; 
int fsr7 = 27;
int fsr8 = 14;
int fsr9 = 12;
int fsr10 = 15;
int fsr11 = 2;

bool deviceConnected = false;
bool oldDeviceConnected = false;
int period = 1000;
unsigned long time_now = 0;
String collate = "";
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;

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
  

  Serial.println("Starting BLE work!");
  BLEDevice::init("BetterSittTESTING");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ   |
                                         BLECharacteristic::PROPERTY_NOTIFY |
                                         BLECharacteristic::PROPERTY_INDICATE
                                       );
  
  pCharacteristic->addDescriptor(new BLE2902());
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  pCharacteristic->setValue("Initialising");
  pCharacteristic->notify();
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");
}

void loop(void) {
    
    //collate = "7, 6, 69, 26, 757, 731, 252, 0, 10";
    if(millis() >= time_now + period){
        time_now += period;
        if (deviceConnected) {
      
        collate = checkReading(fsr1)+","+checkReading(fsr2)+","+checkReading(fsr3)+","+checkReading(fsr4)+","+checkReading(fsr5)+","+checkReading(fsr6)+","+checkReading(fsr7)+","+checkReading(fsr8)+","+checkReading(fsr9)+","+checkReading(fsr10)+","+checkReading(fsr11);
        pCharacteristic->setValue(collate.c_str());
        pCharacteristic->notify();
      
      Serial.print("*** Sent Value: ");
      Serial.print(collate);
      Serial.println(" ***");
 
      }
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
