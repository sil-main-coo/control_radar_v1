import 'package:controlradar/bloc/remote_bloc/remote_radar_bloc.dart';
import 'package:controlradar/bloc/update_data_bloc/bloc.dart';
import 'package:controlradar/constants/mqtt_topic.dart';
import 'package:controlradar/models/mqtt/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ControlDialog extends StatefulWidget {
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
    _sendAction('start');
  }

  void _stop() {
    _sendAction('stop');
  }

  void _up() {
    _sendAction('nang');
  }

  void _down() {
    _sendAction('ha');
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
//        title: _title(),
          child: Padding(
            padding: EdgeInsets.only(
                top: 32.w, bottom: 16.w, right: 32.w, left: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
//          _sliderSpeedWidget(),
//          SizedBox(
//            height: 32.w,
//          ),
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
                fontSize: 22.sp,
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
        'Trình điều khiển',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _aActionButton(
                    Icon(
                      Icons.arrow_upward,
                      size: 72.w,
                    ),
                    'NÂNG',
                    _up),
                _aActionButton(
                    Icon(
                      Icons.arrow_downward,
                      size: 72.w,
                    ),
                    'HẠ',
                    _down),
              ],
            ),
            SizedBox(
              height: ScreenUtil().screenWidth / 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _aActionButton(
                    Icon(
                      Icons.play_arrow,
                      size: 72.w,
                    ),
                    'QUAY',
                    _start),
                _aActionButton(
                    Icon(
                      Icons.stop,
                      size: 72.w,
                    ),
                    'DỪNG',
                    _stop),
              ],
            ),
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
