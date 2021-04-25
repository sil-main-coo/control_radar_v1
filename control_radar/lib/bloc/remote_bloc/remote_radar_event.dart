part of 'remote_radar_bloc.dart';

abstract class RemoteRadarEvent extends Equatable {
  const RemoteRadarEvent();
}

class RemoteAction extends RemoteRadarEvent{
  final Message message;

  RemoteAction({@required this.message}) : assert(message != null);
  @override
  // TODO: implement props
  List<Object> get props => [message];

}
