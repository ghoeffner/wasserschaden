## -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt
import time, datetime
from db import models
from db import wrapper
from actions import *
db_connect = wrapper.db_connect

system_module = SystemModule(2, "mqtt_loop")
system_module.update(1)

def on_connect(client, userdata, flags, rc):
    logger.info("MQTT connected")
    c.on_message = on_message;
    c.subscribe("+/from/+", qos=1)

def on_disconnect(client, userdata, rc):
    if rc != 0:
        log("Unexpected MQTT disconnection. Will auto-reconnect.", 3, 2)

@db_connect
def on_message(mqttc, obj, msg, session):
    system_module.update(1)
    payload = msg.payload.decode()
    bridge = msg.topic.split('/')[0]
    from_node = msg.topic.split('/')[2]
    try:
        house = session.query(models.House).filter(models.House.mqtt_topic == bridge).one()
    except: # bridge not known
        log("Got message from not matching bridge '{}'".format(bridge), 3)
    else: # bridge known
        house.bridge_updated = now()
        if from_node == "bridge":
            if payload == "dead":
                house.bridge_state = 2
                log("bridge in {} went offline".format(house), 3, 2)
            elif payload == "rejected":
                log("bridge in {} rejected a message".format(house), 3, 4)
            else:
                if house.bridge_state > 1:
                    log("bridge in {} is back online, broadcasting ping".format(house), 2, house.bridge_state) # send alert depending on alert state (see timer_loop>check_houses)
                    broadcast_ping(house.mqtt_topic)
                house.bridge_state = 1
                if payload == "Ready!":
                    log("bridge in {} connected to mqtt".format(house), 2, 3)
                elif payload == "pong":
                    log("bridge for {} reponded to ping".format(house), 2)
        else:
            house.bridge_state = 1 # message from node in a house implies that the bridge is still connected
            from_node = int(from_node) # must be a node, and node ids are int
            if session.query(models.Node).filter(models.Node.id == from_node).count() == 1: # check if node exists
                node = session.query(models.Node).filter(models.Node.id == from_node).one()
                if payload == "opening":
                    node.set_physical_state(3)
                elif payload == "closing":
                    if node.physical_state_id == 4: # check if node should really close now
                        node.house.unlock() # only unlock the house if node was meant to close
                    node.set_physical_state(1)
                    for listing in node.queue:
                        session.delete(listing) # delete all queue entries for the node
                elif payload in ["pong","online", "connected"]:
                    node.set_connection_state(1)
                elif payload in ["dropped", "offline", "not connected"]:
                    node.set_connection_state(3)
                elif ":" in payload: # data is sent with ':' inbetween
                    key = payload[0] # the cahr before the ':' specfies the data beeing sent
                    value = payload[2:] # the payload is behind the ':'
                    if key == "t":
                        node.add_temperature(float(value))
                    elif key == "s":
                        changed = False
                        if node.sense is not bool(int(value)):
                            changed = True
                        node.sense = bool(int(value))
                        node.sense_update = now()
                        if (now() - node.initial_connection).seconds < 120: # node send something witin 120s of it's initoal connection
                            if node.has_sense_plate == False:
                                node.has_sense_plate = True
                                log("{} (un)detected water within 2m of it's initial connection, setting has_sense_plate=True".format(node), 1, 1)
                        else:
                            if changed:
                                if not node.has_sense_plate:
                                    ps = " ⚠️ but it should not even have a sense_plate?!"
                                else:
                                    ps = ""
                                if node.sense:
                                    log("{} in {} on {} in {} detected water!{}".format(node, node.flat, node.flat.floor, node.house, ps), 1, 6)
                                else:
                                    log("{} in {} on {} in {} stopped detecting water…{}".format(node, node.flat, node.flat.floor, node.house, ps), 1, 6)
                    elif key == "v":
                        if value == "0":
                            if not node.physical_state_id in [1,4]:
                                log("{} sould not be closed, but was closed".format(node),1,1)
                            node.set_physical_state(1)
                        else:
                            if not node.physical_state_id in [2,3]:
                                log("{} sould not be open, but was open".format(node),2,2)
                            node.set_physical_state(3)
                            node.house.lock()

            else:
                flat = house.new_node_flat
                if flat: # check if flat is set (== not None)
                    new_node = models.Node(id = from_node, flat_id = flat.id,
                                        connection_state_id = 1, physical_state_id = 1,
                                        reported_offline = False,
                                        last_physical_change = now(),
                                        last_connection_change = now(),
                                        last_physical_attempt = now(),
                                        last_connection_attempt = now(),
                                        initial_connection = now(),
                                        house_id = flat.floor.house_id,
                                        has_temperature_sensor = False
                                    )
                    session.add(new_node)
                    session.commit()
                    new_node.send_mqtt_msg("temp")
                    log("Node {} connected for the first time! Addded to flat '{}'".format(new_node, flat), 2, 1)
                else:
                    log("Couldn't add node {} because new_node_flat for {} is not set".format(from_node, house), 3, 2)


def on_log(client, userdata, level, buff):
    if not level == 16:
        logger.warning(buff)

c = mqtt.Client("python-backend-", clean_session = False)
c.connect("localhost", 1883)
c.on_log = on_log
c.on_connect = on_connect
c.on_disconnect = on_disconnect
# c.reconnect_delay_set()
c.loop_forever()
