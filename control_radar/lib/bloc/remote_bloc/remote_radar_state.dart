part of 'remote_radar_bloc.dart';

abstract class RemoteRadarState extends Equatable {
  const RemoteRadarState();
}

class RemoteRadarInitial extends RemoteRadarState {
  @override
  List<Object> get props => [];
}

class RemoteFailure extends RemoteRadarState {
  bool isCurrent;

  RemoteFailure({this.isCurrent = true});

  RemoteFailure copyWith() {
    return RemoteFailure(isCurrent: !this.isCurrent);
  }

  @override
  // TODO: implement props
  List<Object> get props => [isCurrent];
}
