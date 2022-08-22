// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'vertical_text_line.dart';

class MatrixEffect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MatrixEffectState();
  }
}

class _MatrixEffectState extends State<MatrixEffect>
    with WidgetsBindingObserver {
  final List<Widget> _verticalLines = [];
  Timer? timer;
  bool _isInForeground = true;

  @override
  void initState() {
    _startTimer();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _verticalLines);
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _verticalLines.add(_getVerticalTextLine(context));
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Widget _getVerticalTextLine(BuildContext context) {
    Key key = GlobalKey();
    return Positioned(
      key: key,
      left: Random().nextDouble() * MediaQuery.of(context).size.width,
      child: VerticalTextLine(
          onFinished: () {
            setState(() {
              _verticalLines.removeWhere((element) {
                return element.key == key;
              });
            });
          },
          speed: 1 + Random().nextDouble() * 9,
          maxLength: Random().nextInt(10) + 5),
    );
  }
}
