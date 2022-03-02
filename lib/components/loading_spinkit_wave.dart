import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinkitWave extends StatelessWidget {
  final Color color;

  const LoadingSpinkitWave({Key key, this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitWave(color: color),
      ),
    );
  }
}
