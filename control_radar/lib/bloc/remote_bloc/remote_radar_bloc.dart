import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:controlradar/models/mqtt/message.dart';
import 'package:controlradar/providers/mqtt/mqtt_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../get_it.dart';

part 'remote_radar_event.dart';

part 'remote_radar_state.dart';

class RemoteRadarBloc extends Bloc<RemoteRadarEvent, RemoteRadarState> {
  final _mqttService = locator<MQTTService>();

  RemoteRadarBloc() : super(RemoteRadarInitial());

  @override
  Stream<RemoteRadarState> mapEventToState(
    RemoteRadarEvent event,
  ) async* {
    if (event is RemoteAction) {
      yield* _sendMessage(event);
    }
  }

  Stream<RemoteRadarState> _sendMessage(RemoteAction event) async* {
    try {
      _mqttService.sendMessage(event.message);
//      if (event.message.mess.contains('bat') ||
//          event.message.mess.contains('tat'))
//        yield* _mapToUpdateDataState(event.message);
    } catch (e) {
      debugPrint(">>> error: $e");
      if (state is RemoteFailure) {
        yield (state as RemoteFailure).copyWith();
      } else
        yield RemoteFailure();
    }
  }
}
