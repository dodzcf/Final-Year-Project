#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <MQTT.h>
#include <MQTTClient.h>
// #define IN1 D3
// #define BUTTON D5
// #define BUTTON2 D6
// #define BUTTON3 D7
WiFiClient wifiClient;
MQTTClient mqttClient;


// // WiFi
const char *ssid = "DoDz"; // Enter your WiFi name
const char *password = "txmc5702";   // Enter WiFi password

// MQTT Broker
const char *mqtt_broker = "broker.emqx.io";
const char *topic = "my/topic";
const char *topic2 = "my/switch_state";
const char *mqtt_username = "dodz_fyp23";
const char *mqtt_password = "12345623";
const int mqtt_port = 1883;
const char *mqtt_server = "broker.emqx.io";


const int LED_PIN = 5;
const int BUTTON_PIN = 14; // D2
int buttonState = HIGH;
int lastButtonState = LOW;
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 50;

const int LED_PIN2 = 4;
const int BUTTON_PIN2 = 12; // D2
int buttonState2 = HIGH;
int lastButtonState2 = LOW;


const int LED_PIN3 = 0;
const int BUTTON_PIN3 = 13; // D2
int buttonState3 = HIGH;
int lastButtonState3 = LOW;


/////////////FAN CONFIGURATIONS//////////////////
// const int buttonPin = 13; // Button connected to digital pin D1
// const int in1Pin = 0; // IN1 pin of L298N motor driver connected to digital pin D2
const int enablePin = 15; // ENA pin of L298N motor driver connected to digital pin D3
const int speedPin = A0; // Analog input A0 used to control motor speed


/////////////////////FUNCTION CALL BACK FOR MQTT//////////////////
void callback(String topic, String payload) {
  Serial.print("Received a message on topic: ");
  Serial.println(topic);
  Serial.print("Message: ");
  Serial.println(payload);
  if(strcmp(payload.c_str(), "this is my topic, there are many like it but this one is mine") == 0)
  {
    Serial.println("John doe was bugging me");
    return;
  }
  StaticJsonDocument<200> jsonDoc;
  deserializeJson(jsonDoc, payload);
  const char* name = jsonDoc["Name"];
  const char* value = jsonDoc["value"];
if (strcmp(topic.c_str(), "my/topic") == 0)
{
    Serial.print("Topic: ");
    Serial.println(topic.c_str());


  if (strcmp(name, "John Doe") == 0)
  {
    Serial.println("John doe was bugging me");
    return;
  }
//   ////////////LIGHT 1////////////////

  if(strcmp(name, "Light 1") == 0){
      if(strcmp(value, "OFF") == 0)
      {
        digitalWrite(LED_PIN, HIGH);
        Serial.println("Light 1 now off");
        return;
      }
      else if(strcmp(value, "ON") == 0)
      {
        digitalWrite(LED_PIN, LOW);
        Serial.println("Light 1 on now");
        return;
  }
  }
  ////////////LIGHT 2////////////////
  if(strcmp(name, "Light 2") == 0){
      if(strcmp(value, "OFF") == 0)
      {
        digitalWrite(LED_PIN2, LOW);
        Serial.println("Light 2 now off");
        return;
      }
      else if(strcmp(value, "ON") == 0)
      {
        digitalWrite(LED_PIN2, HIGH);
        Serial.println("Light 2 on now");
        return;
  }
  }
  ////////////FAN////////////////

  if(strcmp(name, "Fan") == 0){
      if(strcmp(value, "ON") == 0)
      {
          digitalWrite(LED_PIN3, HIGH);
          // Read analog input and map to motor speed range (0-255)
          int speed = map(analogRead(speedPin), 0, 1023, 0, 255);
          // Set motor speed
          analogWrite(enablePin, speed);
        Serial.println("Fan now off");
        return;
      }
      else if(strcmp(value, "OFF") == 0)
      {
        digitalWrite(LED_PIN3, LOW);
        analogWrite(enablePin, 0);
        Serial.println("Fan on now");
        return;
  }
  }
if (strcmp(name, "Get Data") == 0)
{
    String message = "Here you go data";
  char json[256];
  snprintf(json, sizeof(json), "{\"message\": \"%s\"}", message.c_str());

      Serial.print("Topic: ");
    Serial.println(topic.c_str());


  if (strcmp(value, "ON") == 0)
  {
   StaticJsonDocument<200> message2;
      message2["Light 1"] = digitalRead(D1);
      message2["Light 2"] = digitalRead(D2);
      message2["Fan"] = digitalRead(D3);
      String jsonStr;
      serializeJson(message2, jsonStr);
 Serial.print("\nHere to get data");

 mqttClient.publish("my/switch_state", jsonStr);
 Serial.print("\nSent Data");
 return;  }
  else{
   StaticJsonDocument<200> message2;
      message2["Light 1"] = digitalRead(D1);
      message2["Light 2"] = digitalRead(D2);
      message2["Fan"] = digitalRead(D3);
      String jsonStr;
      serializeJson(message2, jsonStr);
 Serial.print("\nHere to get data");

 mqttClient.publish("my/switch_state", jsonStr);
 Serial.print("\nSent Data");
 return;
  }
}
// // Serial.print("Received");
}
}



void setup() {
  Serial.begin(115200);

///////////////////////LIGHT 1/////////////////////////
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);
    pinMode(BUTTON_PIN, INPUT_PULLUP);



///////////////////////LIGHT 2/////////////////////////
    pinMode(LED_PIN2, OUTPUT);
    digitalWrite(LED_PIN2, LOW);
    pinMode(BUTTON_PIN2, INPUT_PULLUP);


///////////////////////FAN#1/////////////////////////
    pinMode(LED_PIN3, OUTPUT);
    digitalWrite(LED_PIN3, LOW);
    pinMode(BUTTON_PIN3, INPUT_PULLUP);


///////////////////////FAN/////////////////////////

      // pinMode(buttonPin, INPUT_PULLUP);
  // pinMode(in1Pin, OUTPUT);
  pinMode(enablePin, OUTPUT);
  // // Turn off motor initially
  // digitalWrite(in1Pin, HIGH);
  analogWrite(enablePin, 0);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  



  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  mqttClient.begin(mqtt_server, mqtt_port, wifiClient);
  mqttClient.onMessage(callback);
  mqttClient.connect("ESP8266Client2", mqtt_username, mqtt_password);
  mqttClient.subscribe("my/topic");

}




///////////LOOOOOOOOPPPPPPP/////////////
void loop() {
  mqttClient.loop();
  if (!mqttClient.connected()) {
    reconnect();
  }


//////////button 1///////////
  int reading = digitalRead(BUTTON_PIN);
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;
      if (buttonState == HIGH) {
        if(digitalRead(LED_PIN)==0)
        {
          digitalWrite(LED_PIN, HIGH);
          Serial.println("Turned on HIGH");
        }
        else if(digitalRead(LED_PIN)==1)
        {
          digitalWrite(LED_PIN, LOW);
          Serial.println("Turned on LOW");
        }
      } 
 
    }
  }

  lastButtonState = reading;


  //////////button 2///////////
  int reading2 = digitalRead(BUTTON_PIN2);
  if (reading2 != lastButtonState2) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading2 != buttonState2) {
      buttonState2 = reading2;
      if (buttonState2 == HIGH) {
        if(digitalRead(LED_PIN2)==0)
        {
          digitalWrite(LED_PIN2, HIGH);
          Serial.println("Turned on HIGH");
        }
        else if(digitalRead(LED_PIN2)==1)
        {
          digitalWrite(LED_PIN2, LOW);
          Serial.println("Turned on LOW");
        }
      } 
 
    }
  } 
    lastButtonState2 = reading2;


  ////////button 3///////////
  int reading3 = digitalRead(BUTTON_PIN3);
  if (reading3 != lastButtonState3) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading3 != buttonState3) {
      buttonState3 = reading3;
      if (buttonState3 == HIGH) {
        if(digitalRead(LED_PIN3)==0)
        {
          digitalWrite(LED_PIN3, HIGH);
          // Read analog input and map to motor speed range (0-255)
          int speed = map(analogRead(speedPin), 0, 1023, 0, 255);
          // Set motor speed
          analogWrite(enablePin, speed);
          Serial.println("Turned on HIGH");
        }
        else if(digitalRead(LED_PIN3)==1)
        {
          digitalWrite(LED_PIN3, LOW);
          analogWrite(enablePin, 0);
          Serial.println("Turned on LOW");
        }
      } 
 
    }
  } 
    lastButtonState3 = reading3;









  
 
}

void reconnect() {
  // Loop until we're reconnected
  while (!mqttClient.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (mqttClient.connect("ESP8266Client", mqtt_username, mqtt_password )) {
      Serial.println("connected");
      // Once connected, subscribe to the topic
      mqttClient.subscribe(topic);
      mqttClient.subscribe(topic2);
    } else {
      Serial.print("failed, rc=");
      // Serial.print(mqttClient.state());
      Serial.println(" retrying in 5 seconds");
      delay(5000);
    }
  }
}
 


