import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../style.dart';
import '../main.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  CalendarController _calendarController;

@override
void initState() {
  super.initState();
  _calendarController = CalendarController();
}

@override
void dispose() {
  _calendarController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
    calendarController: _calendarController,
  );
  }
}