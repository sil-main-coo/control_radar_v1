import 'dart:io';
import 'dart:math';

import 'package:controlradar/bloc/update_data_bloc/bloc.dart';
import 'package:controlradar/control_dialog/control_dialog.dart';
import 'package:controlradar/radar_widget/out_circle_widget.dart';
import 'package:controlradar/radar_widget/radar_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:controlradar/radar_widget/point_widget.dart';
import 'package:controlradar/radar_widget/radar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/mqtt_bloc/bloc.dart';
import 'bloc/mqtt_bloc/mqtt_bloc.dart';
import 'bloc/remote_bloc/remote_radar_bloc.dart';
import 'bloc/update_data_bloc/update_data_bloc.dart';
import 'bloc_delegate.dart';
import 'get_it.dart';

void main() {
  bool kisweb;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      kisweb = false;
    } else {
      kisweb = true;
    }
  } catch (e) {
    kisweb = true;
  }

  if (!kisweb) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  setupLocator(); // setup get it : MQTT service
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateDataBloc>(
            create: (context) => locator<UpdateDataBloc>()),
        BlocProvider<RemoteRadarBloc>(
            create: (context) => locator<RemoteRadarBloc>()),
        BlocProvider<MQTTBloc>(
            create: (context) =>
                locator<MQTTBloc>()..add(ConnectMQTTService())),
      ],
      child: ScreenUtilInit(
        designSize: Size(1364, 697),
        builder: (ct, child) => MaterialApp(
          title: 'Control Radar',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            body: BlocBuilder<MQTTBloc, MQTTState>(
              builder: (context, state) {
                if (state is ConnectedMQTT) {
                  return RadarPage();
                }
                if (state is ConnectMQTTFailedState)
                  return Text(
                    'Lỗi',
                    style: TextStyle(fontSize: 30, color: Colors.red),
                  );
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RadarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        BlocConsumer<UpdateDataBloc, UpdateDataState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LoadedData) {
              return _body(context, state);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'assets/bg_top.png',
            height: RadarConstants.topPos,
            width: size.width,
            fit: BoxFit.fill,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/bg_bottom.png',
            height: RadarConstants.bottomPos,
            width: size.width,
            fit: BoxFit.fill,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: _controlButtons(context),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/bg_left.png',
              height: size.height,
              width: RadarConstants.leftPos,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }

  Widget _body(BuildContext context, LoadedData state) {
//    print('>> height: ${ScreenUtil().screenHeight}');
//    print('>> width: ${ScreenUtil().screenWidth}');
    return Container(
      color: Color(0xFF444d6a),
      child: Stack(
        children: [
          Positioned.fill(
            left: RadarConstants.leftPos,
            right: RadarConstants.rightPos,
            bottom: RadarConstants.bottomPos,
            top: RadarConstants.topPos,
            child: Center(
              child: Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: OutCircleView(
                    radius: state.radius,
                  ),
                ),
                Transform.rotate(
                  angle: -pi / 2,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: RadarView(
                          radius: state.radius,
                          angle: state.angle,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: PointsWidget(
                            points: state.points,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _controlButtons(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: Column(
        children: [
          Expanded(
            child: _buttonItem(
                context,
                'QUAY ĂNGTEN',
                () => _showControlDialog(
                    context, 'QUAY ĂNGTEN', ControlType.quayAngten)),
          ),
          Expanded(
            child: _buttonItem(
                context,
                'NÂNG/HẠ ĂNGTEN',
                () => _showControlDialog(
                    context, 'NÂNG HẠ ĂNGTEN', ControlType.nangHaAngten)),
          ),
          Expanded(
            child: _buttonItem(
                context,
                'KÍCH TRÁI',
                () => _showControlDialog(
                    context, 'KÍCH TRÁI', ControlType.kichTrai)),
          ),
          Expanded(
            child: _buttonItem(
                context,
                'KÍCH PHẢI',
                () => _showControlDialog(
                    context, 'KÍCH PHẢI', ControlType.kichPhai)),
          ),
          Expanded(
            child: _buttonItem(
                context,
                'KÍCH SAU',
                () => _showControlDialog(
                    context, 'KÍCH SAU', ControlType.kichSau)),
          ),
        ],
      ),
    );
  }

  Widget _buttonItem(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.maxFinite,
      child: FlatButton(
        padding: EdgeInsets.all(16),
        onPressed: onPressed,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.green, width: 1, style: BorderStyle.solid)),
        child: Text(
          label,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showControlDialog(
      BuildContext context, String title, ControlType type) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ControlDialog(
            title: title,
            type: type,
          );
        });
  }
}
