import 'dart:math';

import 'package:controlradar/bloc/update_data_bloc/bloc.dart';
import 'package:controlradar/constants/mqtt_topic.dart';
import 'package:controlradar/radar_widget/radar_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// @Singleton
class UpdateDataBloc extends Bloc<UpdateDataEvent, UpdateDataState> {

  List<Offset> _points = [];
  double _radius;
  double _lastAngle = 0.0;
  double _currentAngle = 0.0;

  UpdateDataBloc() : super(LoadingData());

  @override
  Stream<UpdateDataState> mapEventToState(UpdateDataEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitData) {
      _radius = RadarConstants.radius;
      yield LoadedData(radius: _radius);
    } else if (event is UpdateData) {
      yield* _updateData(event);
    }
  }

  Stream<UpdateDataState> _updateData(UpdateData event) async* {
    // yield LoadingState();
    final currentState = state;
    if (currentState is LoadedData) {
      try {
        final mess = event.message.mess;
        if (mess != null && mess.isNotEmpty) {
          final topic = event.message.topic;
          if (topic == MqttTopicConstant.followTopic) {
            debugPrint(event.message.mess);

            final data = event.message.mess.split('#');
            final rActual = double.parse(data[1]);

            _lastAngle = _currentAngle;
            _currentAngle = double.parse(data[0]);

            if (_lastAngle ~/ 6 == 1 && _currentAngle ~/ 1 == 0) {
              _points.clear();
            }

            if (rActual <= 500) {
              /// radius/min(width, height) <=> 500cm
              /// ? <=> r
              final rSimulatorPoint = _radius * rActual / 500;
              final dx = rSimulatorPoint * cos(_currentAngle);
              final dy = rSimulatorPoint * sin(_currentAngle);

              _points.add(Offset(RadarConstants.maxWidthRadius / 2 + dx,
                  RadarConstants.maxHeightRadius / 2 + dy));

              debugPrint(_points.toString());
            }

            yield currentState.copyWith(angle: _currentAngle, points: _points);
          }
        }
      } catch (e) {
        print(e);
        yield FailedData();
      }
    }
  }
//
//  Stream<UpdateDataState> _mapToUpdateDataState(Message message) async* {
//    final currentState = state;
//    if (currentState is LoadedData) {
//      try {
//        final mess = message.mess;
//        final classroom =
//            currentState.classrooms[0]; // todo: index of classroom changed
//
//        String nameDevice =
//            'tb${mess[mess.length - 1]}'; // lấy index của thiết bị trong msg
//        String newMess = '';
//
//        for (int i = 0; i < classroom.devices.devices.length; i++) {
//          if (classroom.devices.devices[i].name == nameDevice) {
//            newMess =
//                '$newMess$nameDevice:${classroom.devices.devices[i].status == 1 ? 0 : 1}';
//          } else {
//            newMess = '$newMess${classroom.devices.devices[i].toMess()}';
//          }
//          if (i < classroom.devices.devices.length - 1) {
//            newMess = '$newMess/';
//          }
//        }
//        message.mess = newMess;
//        message.topic = classroom.devices.topicString;
//
//        // if status devices changed
//        classroom.devices.setDevices(message.mess);
//        final List<Classroom> update = List.from(currentState.classrooms)
//          ..[0] = classroom;
//        yield currentState.copyWith(classrooms: update);
//      } catch (e) {
//        debugPrint(">>> error: $e");
//        yield FailedData(error: e);
//      }
//    }
//  }
}
