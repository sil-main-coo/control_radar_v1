import 'dart:io';
import 'dart:math';
import 'package:controlradar/models/mqtt/message.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// @Singleton
class MQTTService {
//  MqttServerClient _serverClient;
//  MqttBrowserClient _browserClient;

  MqttClient client;

  final String _host = 'broker.hivemq.com';
  final int _port = 1883;
  final String _clientIdentifier = 'kma_${Random().nextInt(99)}';
  final int _keepAlivePeriod = 30;
  final bool _autoReconnect = false;

  bool _isWeb = false;

  void _onConnected() {
    debugPrint('>>> Connected');
  }

  void _onDisconnected() {
    debugPrint('>>> Client disconnection');
  }

  void _onSubscribed(String topic) {
    debugPrint('>>> Subscription $topic');
  }

  void _onUnsubscribed(String topic) {
    debugPrint('>>> UnSubscription $topic');
  }

  /// Pong callback
  void _pong() {
    debugPrint('>>> Ping response client callback invoked');
  }

  void initMQTT() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _isWeb = false;
      } else {
        _isWeb = true;
      }
    } catch (e) {
      _isWeb = true;
    }

    if (!_isWeb) {
      client = MqttServerClient(_host, '');
      client.port = _port;
    } else {
      client = MqttBrowserClient.withPort(
          'ws://$_host/mqtt', _clientIdentifier, 8000);
      client.websocketProtocols = ['mqtt', 'mqttv3.1', 'mqttv3.11'];
    }

    _initMQTTClient();
  }

  void _initMQTTClient() {
    client.onConnected = _onConnected;
    client.keepAlivePeriod = _keepAlivePeriod;
//    client.logging(on: true); // logging if u want
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.onUnsubscribed = _onUnsubscribed;
    client.autoReconnect = _autoReconnect;
    client.pongCallback = _pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(_clientIdentifier)
        .keepAliveFor(30) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('Test message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;
  }

  Future<MqttClientConnectionStatus> connectMQTT() async {
    try {
      final result = await client.connect();

      return result;
    } on Exception catch (e) {
      client.disconnect();
      throw Exception('Client MQTT exception - $e');
    }
  }

  disconnectMQTT() => client.disconnect();

  sendMessage(Message message) {
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message.mess);
      client.publishMessage(message.topic, message.qos, builder.payload);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
