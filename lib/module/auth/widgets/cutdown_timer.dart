import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    super.key,
    required this.countDownTimerStyle,
    required this.whenTimeExpires,
    this.countDownFormatter,
    required this.secondsRemaining,
  });

  final int secondsRemaining;
  final Function(bool, bool, bool) whenTimeExpires;
  final Function? countDownFormatter;
  final TextStyle countDownTimerStyle;

  @override
  State createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  Duration? duration;
  var log = Logger();

  String get timerDisplayString {
    var duration = (_controller.duration ?? Duration.zero) * _controller.value;
    return widget.countDownFormatter != null ? widget.countDownFormatter!(duration.inSeconds) : Utility().formatHHMMSS(duration.inSeconds);
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller.reverse(from: widget.secondsRemaining.toDouble());
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.whenTimeExpires(false, false, true);
      }
    });
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = Duration(seconds: widget.secondsRemaining);
        _controller.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller.reverse(from: widget.secondsRemaining.toDouble());
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.whenTimeExpires(false, false, true);
          } else if (status == AnimationStatus.dismissed) {
            log.i('Animation Complete');
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (_, Widget? child) {
              return Text(
                timerDisplayString,
                style: widget.countDownTimerStyle,
              );
            }));
  }
}
