import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

List<LaneEvents> ScheduleHeader({double width, BuildContext context}) {
  return [
        LaneEvents(
            lane: Lane(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
                name: 'SUN',
                width: (width / 8),
                textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
            events: []),
        LaneEvents(
            lane: Lane(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
                name: 'MON',
                width: (width / 8),
                textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
            events: []),
        LaneEvents(
          lane: Lane(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
              name: 'TUE',
              width: (width / 8),
              textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
          events: [],
        ),
        LaneEvents(
          lane: Lane(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
              name: 'WED',
              width: (width / 8),
              textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
          events: [],
        ),
        LaneEvents(
          lane: Lane(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
              name: 'THU',
              width: (width / 8),
              textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
          events: [],
        ),
        LaneEvents(
          lane: Lane(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
              name: 'FRI',
              width: (width / 8),
              textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
          events: [],
        ),
        LaneEvents(
          lane: Lane(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
              name: 'SAT',
              width: (width / 8),
              textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
          events: [],
        ),
      ];
}