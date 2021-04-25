import 'package:controlradar/models/mqtt/message.dart';
import 'package:equatable/equatable.dart';

class UpdateDataEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitData extends UpdateDataEvent {
  final double angle;

  InitData({this.angle = .0});

  @override
  // TODO: implement props
  List<Object> get props => [angle];
}

class UpdateData extends UpdateDataEvent {
  final Message message;

  UpdateData({this.message}) : assert(message != null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}