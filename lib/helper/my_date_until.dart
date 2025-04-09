import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUril{
  static String getFormattesTime(
  { required BuildContext context, required String time})
  {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}