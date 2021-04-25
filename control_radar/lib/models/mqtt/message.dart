import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';

class Message extends Equatable {
  String mess;
  String topic;
  MqttQos qos;

  Message({this.mess, this.topic, this.qos,});

  @override
  // TODO: implement props
  List<Object> get props => [topic, qos, mess];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}