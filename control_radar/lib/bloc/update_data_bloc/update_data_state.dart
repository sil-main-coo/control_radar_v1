import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UpdateDataState extends Equatable {
  const UpdateDataState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingData extends UpdateDataState {}

class ShowDialogDataState extends UpdateDataState {}

class LoadedData extends UpdateDataState {
  final double angle;
  final double radius;
  final List<Offset> points;
  final bool isChange; //  >>> todo : lỗi currentState  = newState ???

  const LoadedData(
      {this.angle = .0,
      @required this.radius,
      this.points = const [],
      this.isChange = true});

  LoadedData copyWith({double angle, double radius, List<Offset> points}) {
    return LoadedData(
        angle: angle ?? this.angle,
        radius: radius ?? this.radius,
        isChange: !this.isChange,
        points: points ?? this.points);
  }

  @override
  // TODO: implement props
  List<Object> get props => [angle, isChange, points, radius];
}

class FailedData extends UpdateDataState {
  final Exception error;

  FailedData({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FailedData { error: $error }';
}

class RemoteSuccess extends UpdateDataState {}
