#include <Arduino.h>
#include <painlessMesh.h>
#include <PubSubClient.h>
#include <WiFiClient.h>
#include "settings.cpp" //contains passwords

#define POWER_LED D0
#define WLAN_LED D2
#define MESH_LED D5
#define MQTT_LED D6
#define MQTT_RX_LED D1
#define MESH_RX_LED D3

#define   MESH_PORT       5555
#define HOSTNAME "MQTT_Bridge"

int leds[6] = {POWER_LED, WLAN_LED, MESH_LED, MESH_RX_LED, MQTT_LED, MQTT_RX_LED,};

// Prototypes
void receivedCallback(uint32_t from, String msg );
void mqttCallback(char* topic, byte* payload, unsigned int length);
void mqttConnect();
void mqtt_led_off();
void mesh_led_off();

char* message_buff;

String msg_ping = "ping";
String msg_welcome = "welcome";

const String from_bridge = String(MQTT_TOPIC)+"/from/bridge";

unsigned long last_msg;

int open_nodes = 0;
unsigned long last_open_msg;

IPAddress getlocalIP();

IPAddress no_ip(0, 0, 0, 0);
IPAddress myIP(0, 0, 0, 0);
IPAddress mqttBroker(6, 6, 6, 1);

painlessMesh  mesh;
WiFiClient wifiClient;
PubSubClient mqttClient(mqttBroker, 1883, mqttCallback, wifiClient);


Scheduler userScheduler;
Task reconnect(1000, TASK_FOREVER, &mqttConnect);
Task mqtt_blink(50, 1, &mqtt_led_off);
Task mesh_blink(50, 1, &mesh_led_off);

void setup() {
  ESP.wdtEnable(5000);
  pinMode(POWER_LED, OUTPUT);
  pinMode(WLAN_LED, OUTPUT);
  pinMode(MESH_LED, OUTPUT);
  pinMode(MQTT_LED, OUTPUT);
  pinMode(MQTT_RX_LED, OUTPUT);
  pinMode(MESH_RX_LED, OUTPUT);
  for(int i = 0; i < 6; i++){
    digitalWrite(leds[i], HIGH);
    delay(100);
    digitalWrite(leds[i], LOW);
  }
  last_msg = millis();
  Serial.begin(115200);
  digitalWrite(POWER_LED, HIGH);
  mesh.setRoot();
  mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );

  mesh.init( MESH_PREFIX, MESH_PASSWORD, MESH_PORT, WIFI_AP_STA, 4);
  mesh.onReceive(&receivedCallback);

  mesh.onNewConnection([](const uint32_t nodeId) {
    digitalWrite(MESH_LED, HIGH);
    if (nodeId != 0) {
      String topic = String(MQTT_TOPIC)+"/from/" + String(nodeId);
      mqttClient.publish((topic.c_str()), "connected");
      Serial.printf("New Connection \n", nodeId);
    }
  });

  mesh.onDroppedConnection([](const uint32_t nodeId) {
    if (nodeId != 0) {
      String topic = String(MQTT_TOPIC)+"/from/" + String(nodeId);
      mqttClient.publish(topic.c_str(), "dropped");
      Serial.printf("Dropped Connection %u\n", nodeId);
    }
    if (mesh.subConnectionJson().length() < 3) {
      digitalWrite(MESH_LED, LOW);
    }
  });

  mesh.stationManual(STATION_SSID, STATION_PASSWORD);
  mesh.setHostname(HOSTNAME);

  userScheduler.addTask(mesh_blink);
  userScheduler.addTask(mqtt_blink);
  userScheduler.addTask(reconnect);
}

void mqttConnect() {
  if (mqttClient.connect(String("pmC_"+String(MQTT_TOPIC)).c_str())) {
    digitalWrite(MQTT_LED, HIGH);
    Serial.println("connected to mqtt");
    mqttClient.publish(from_bridge.c_str(), "Ready!");
    mqttClient.subscribe(String(String(MQTT_TOPIC)+"/to/#").c_str(), 0);
    reconnect.disable();
  } else {
    digitalWrite(MQTT_LED, LOW);
  }
}

void mqtt_led_off() {
  if (mqtt_blink.isLastIteration()) {
    digitalWrite(MQTT_RX_LED, LOW);
    mqtt_blink.disable();
    mqtt_blink.setIterations(2);
  }
}

void mesh_led_off() {
  if (mesh_blink.isLastIteration()) {
    digitalWrite(MESH_RX_LED, LOW);
    mesh_blink.disable();
    mesh_blink.setIterations(2);
  }
}

void loop() {
  if(millis() < last_msg){ //reset last_msg when millis overflows every ~50 days
    last_msg = millis();
  }
  else if(millis() - last_msg > 1800000) { // half an hour
    ESP.reset(); //reset the esp when the last mqtt message was received to long ago
  }
  mesh.update();
  mqttClient.loop();

  if (myIP != getlocalIP()) {
    analogWrite(WLAN_LED, 200);
    myIP = getlocalIP();
    Serial.println("My IP is " + myIP.toString());
    mqttConnect();
  }
  if (myIP == no_ip) {
    digitalWrite(WLAN_LED, LOW);
  } else {
    analogWrite(WLAN_LED, 200);
  }
  if (!mqttClient.connected() and !reconnect.isEnabled()) {
    reconnect.enable();
    Serial.println("enabled reconnect task");
  }
  userScheduler.execute();
}

void receivedCallback(uint32_t from, String msg ) {
  digitalWrite(MESH_RX_LED, HIGH);
  Serial.printf("bridge: Received from %u msg=%s\n", from, msg.c_str());
  String topic = String(MQTT_TOPIC)+"/from/" + String(from);
  mqttClient.publish(topic.c_str(), msg.c_str());
  mesh_blink.enable();
  if(msg == "online"){
    mesh.sendSingle(from, msg_welcome);
  }else if(msg == "closing")
  {
    if(open_nodes > 0)
    {
      open_nodes -= 1;
    }
  }
}

void mqttCallback(char* topic, uint8_t* payload, unsigned int length) {
  last_msg = millis();
  digitalWrite(MQTT_RX_LED, HIGH);
  
  char* cleanPayload = (char*)malloc(length+1);
  payload[length] = '\0';
  memcpy(cleanPayload, payload, length+1);
  String msg = String(cleanPayload);
  free(cleanPayload);

  String targetStr = String(topic).substring(String(MQTT_TOPIC).length()+4);
  if (targetStr == "bridge")
  {
    if (msg == "getNodes")
    {
      Serial.println( mesh.subConnectionJson().c_str());
      mqttClient.publish(from_bridge.c_str(), mesh.subConnectionJson().c_str());
    }else if(msg == "ping")
    {
      Serial.println("ping recived, sending pong");
      mqttClient.publish(from_bridge.c_str(), "pong");
    }
  }
   else if(targetStr == "broadcast") 
  {
    if(msg != "open") // let's just don't broadcast open msgs
    {
      Serial.println("broadcasting to mesh: " + msg);
      mesh.sendBroadcast(msg);
    }else{
      String pubtopic = String(MQTT_TOPIC)+"/from/bridge";
      mqttClient.publish(pubtopic.c_str(), "rejected");
      Serial.println("rejected broadcast");
    }
  }
  else
  {
    uint32_t target = strtoul(targetStr.c_str(), NULL, 10);
    if (mesh.isConnected(target))
    {
      if (msg == "open")
      {
        if(millis() < last_open_msg){ // reset last_open_msg when millis overflows every ~50 days
            last_open_msg = millis();
        }
        else if(millis() - last_open_msg > 120000) // check if last open msg happened 2 minutes ago
        {
          open_nodes = 0;
        }
        if(open_nodes == 0)
        {
          last_open_msg = millis();
          open_nodes += 1;
          Serial.println("sending " + msg+ " to " + target);
          mesh.sendSingle(target, msg);
        }
        else // reject open command, since there might be more open nodes
        {
          String pubtopic = String(MQTT_TOPIC)+"/from/bridge";
          mqttClient.publish(pubtopic.c_str(), "rejected");
          Serial.println("rejected open command");
        }
      }
      else
      {
       mesh.sendSingle(target, msg);
       Serial.println("sending " + msg+ " to " + target);
      }
   }
   else
   {
    String pubtopic = String(MQTT_TOPIC)+"/from/" + targetStr;
    mqttClient.publish(pubtopic.c_str(), "offline");
   }
  }
  mqtt_blink.enable();
}

IPAddress getlocalIP() {
  return IPAddress(mesh.getStationIP());
}
