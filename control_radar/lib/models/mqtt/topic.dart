import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';

class AppTopic extends Equatable {
  String topicString;
  MqttQos qos;

  AppTopic({this.topicString, this.qos});

  AppTopic.fromJson(Map<String, dynamic> json) {
    topicString = json['topic_string'];
    final level = json['qos'];
    switch(level){
      case 0:
        qos= MqttQos.atLeastOnce;
        break;
      case 1:
        qos= MqttQos.exactlyOnce;
        break;
      case 2:
        qos= MqttQos.atMostOnce;
        break;
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}