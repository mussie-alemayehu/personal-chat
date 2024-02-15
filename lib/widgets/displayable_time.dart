import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayableTime extends StatelessWidget {
  final DateTime time;

  const DisplayableTime(this.time, {super.key});

  String get _displayableTime {
    final now = DateTime.now();
    String displayableTime;
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      displayableTime = DateFormat(DateFormat.HOUR_MINUTE).format(time);
    } else if (time.day == now.day - 1 &&
        time.month == now.month &&
        time.year == now.year) {
      displayableTime = 'yest';
    } else {
      displayableTime = DateFormat(DateFormat.ABBR_MONTH_DAY).format(time);
    }
    return displayableTime;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayableTime,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 11,
          ),
    );
  }
}
