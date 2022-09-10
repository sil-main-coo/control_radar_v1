import 'package:controlradar/bloc/remote_bloc/remote_radar_bloc.dart';
import 'package:controlradar/constants/mqtt_topic.dart';
import 'package:controlradar/models/mqtt/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum ControlType { chanKich1, chanKich2, chanKich3, nangHaAngten, quayAngten }

class ControlDialog extends StatefulWidget {
  final String title;
  final ControlType type;

  ControlDialog({@required this.title, @required this.type});

  @override
  _ControlDialogState createState() => _ControlDialogState();
}

class _ControlDialogState extends State<ControlDialog> {
  double _currentSliderValue;

  @override
  void initState() {
    // TODO: implement initState
    _currentSliderValue = 20;
    super.initState();
  }

  void _sendAction(String action) {
    BlocProvider.of<RemoteRadarBloc>(context).add(RemoteAction(
        message: Message(
            mess: action,
            topic: MqttTopicConstant.remoteTopic,
            qos: MqttQos.atMostOnce)));
  }

  void _start() {
    if (widget.type == ControlType.quayAngten) {
      _sendAction('quay_12');
    }
  }

  void _stop() {
    switch (widget.type) {
      case ControlType.chanKich1:
        _sendAction('dung_chan_kich_1');
        break;
      case ControlType.chanKich2:
        _sendAction('dung_chan_kich_2');
        break;
      case ControlType.chanKich3:
        _sendAction('dung_chan_kich_3');
        break;
      case ControlType.nangHaAngten:
        _sendAction('dung_angten');
        break;
      case ControlType.quayAngten:
        _sendAction('dung_quay_angten');
        break;
    }
  }

  void _up() {
    switch (widget.type) {
      case ControlType.chanKich1:
        _sendAction('nang_chan_kich_1');
        break;
      case ControlType.chanKich2:
        _sendAction('nang_chan_kich_2');
        break;
      case ControlType.chanKich3:
        _sendAction('nang_chan_kich_3');
        break;
      case ControlType.nangHaAngten:
        _sendAction('nang_angten');
        break;
      case ControlType.quayAngten:
        break;
    }
  }

  void _down() {
    switch (widget.type) {
      case ControlType.chanKich1:
        _sendAction('ha_chan_kich_1');
        break;
      case ControlType.chanKich2:
        _sendAction('ha_chan_kich_2');
        break;
      case ControlType.chanKich3:
        _sendAction('ha_chan_kich_3');
        break;
      case ControlType.nangHaAngten:
        _sendAction('ha_angten');
        break;
      case ControlType.quayAngten:
        _sendAction('ha_angten');
        break;
    }
  }

  void _showErrorDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text('Lỗi'),
              content: Text('Đã xảy ra lỗi. Vui lòng kiểm tra lại kết nối'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoteRadarBloc, RemoteRadarState>(
      listener: (context, state) {
        if (state is RemoteFailure) {
          _showErrorDialog();
        }
      },
      child: SizedBox(
        height: ScreenUtil().screenHeight / 1.5,
        width: ScreenUtil().screenWidth / 1.5,
        child: Dialog(
          child: Padding(
            padding: EdgeInsets.only(
                top: 32.w, bottom: 16.w, right: 32.w, left: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                SizedBox(
                  height: ScreenUtil().screenWidth / 20,
                ),
                Expanded(child: _actionButtonsWidget()),
                _action(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _action() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ĐÓNG',
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _title() {
    return Center(
      child: Text(
        widget.title,
        style: TextStyle(
            fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sliderSpeedWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tốc độ: ',
          style: TextStyle(fontSize: 22.sp, color: Colors.black),
        ),
        SfSlider(
          min: 5.0,
          max: 20.0,
          value: _currentSliderValue,
          interval: 5.0,
          stepSize: 5,
          showTicks: true,
          showLabels: true,
          enableTooltip: true,
          onChanged: (dynamic value) {
            setState(() {
              if (value is double) _currentSliderValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget _actionButtonsWidget() {
    return Center(
      child: SizedBox(
        width: ScreenUtil().screenWidth / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.type == ControlType.quayAngten,
              child: _aActionButton(
                  Icon(
                    Icons.play_arrow,
                    size: 72.w,
                  ),
                  '12',
                  _start),
            ),
            Visibility(
              visible: widget.type != ControlType.quayAngten,
              child: _aActionButton(
                  Icon(
                    Icons.arrow_upward,
                    size: 72.w,
                  ),
                  'LÊN',
                  _up),
            ),
            SizedBox(
              height: ScreenUtil().screenWidth / 25,
            ),
            _aActionButton(
                Icon(
                  Icons.stop,
                  size: 72.w,
                ),
                'DỪNG',
                _stop),
            SizedBox(
              height: ScreenUtil().screenWidth / 25,
            ),
            _aActionButton(
                Icon(
                  Icons.arrow_downward,
                  size: 72.w,
                ),
                'XUỐNG',
                _down),
          ],
        ),
      ),
    );
  }

  Widget _aActionButton(Widget icon, String label, Function function) {
    return FlatButton(
      onPressed: function,
      padding: EdgeInsets.symmetric(vertical: 8),
      textColor: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            label,
            style: TextStyle(fontSize: 24.sp),
          )
        ],
      ),
    );
  }
}
