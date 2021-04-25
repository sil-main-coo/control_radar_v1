import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MQTTState extends Equatable{
  const MQTTState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingState extends MQTTState{}

//class HasInitializedMQTT extends MQTTState{}

class ConnectedMQTT extends MQTTState{}

class DisconnectedMQTT extends MQTTState{}

class ConnectMQTTFailedState extends MQTTState{
  final String error;

  ConnectMQTTFailedState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'MQTT Failure { error: $error }';
}

class SendMsgFailed extends MQTTState{}
