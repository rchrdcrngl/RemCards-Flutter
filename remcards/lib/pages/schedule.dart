import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:get/get.dart';
import 'package:remcards/components/notifications.dart';
import 'package:remcards/pages/add_schedule.dart';
import 'package:remcards/pages/components/request_header.dart';
import 'package:remcards/pages/components/schedule_header.dart';
import 'package:remcards/pages/edit_schedule.dart';
import '../const.dart';
import 'components/app_bar.dart';
import 'components/day_table.dart';
import 'components/period.dart';

class SchedulePage extends StatefulWidget {
  final bool isRefresh;
  SchedulePage({Key key, this.isRefresh = false}) : super(key: key);
  static _SchedulePageState of(BuildContext context) =>
      context.findAncestorStateOfType<_SchedulePageState>();
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

processNotification(List<DaySchedule> resp) async {
  print("STARTING TO PROCESS NOTIF");
  for (DaySchedule day in resp) {
    if (day.data != null) {
      day.data.forEach((element) {
        Period p = Period.fromJson(day.day, element);
        createScheduledNotification(1, p.day, p.hourStart, p.minStart, p.name);
      });
    }
  }
  print("All notifications are scheduled");
}

Map<int, String> numToDay = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday'
};

class _SchedulePageState extends State<SchedulePage> {
  List<DaySchedule> DayScheduleList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    if (widget.isRefresh) {
      _refresh();
    }
  }

  add() => Get.to(() => addSchedForm(refresh: _refresh));

  _refresh() => setState(() {
        refresh();
      });

  fetchData() async {
    print("load-posts");
    fetchPost().then((data) {
      setState(() {
        DayScheduleList = data;
      });
    });
  }

  Future<Null> refresh() async {
    APICacheManager().deleteCache("API-Schedule");
    cancelScheduledNotifications();
    setState(() {
      fetchData();
    });
    return null;
  }

  Future fetchPost([howMany = 5]) async {
    var cacheExists =
        await APICacheManager().isAPICacheKeyExist("API-Schedule");

    if (!cacheExists) {
      //Data has not yet cached

      final headers = await getRequestHeaders();
      final response = await http.get(Uri.parse(schedURI), headers: headers);

      if (response.statusCode == 200) {
        APICacheDBModel cacheDBModel =
            new APICacheDBModel(key: "API-Schedule", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        List jsonResponse = json.decode(response.body);
        var data =
            jsonResponse.map((day) => new DaySchedule.fromJson(day)).toList();

        processNotification(data);
        return data;
      } else {
        throw Exception('Failed to load Schedule');
      }
    } else {
      //Data is already cached
      var cacheData = await APICacheManager().getCacheData("API-Schedule");
      List jsonResponse = json.decode(cacheData.syncData);
      return jsonResponse.map((day) => new DaySchedule.fromJson(day)).toList();
    }
  }

  List PeriodBuilder(DaySchedule daytbl) {
    List<TableEvent> a = [];
    if (daytbl.data != null) {
      daytbl.data.forEach((element) {
        Period tbe = Period.fromJson(daytbl.day, element);
        a.add(tbe.convert(edit: edit));
      });
      return a;
    } else {
      return [];
    }
  }

  List<LaneEvents> _buildLaneEvents(double width) {
    List<LaneEvents> list = [];
    if (DayScheduleList.isNotEmpty) {
      DayScheduleList.forEach((element) {
        list.add(LaneEvents(
            lane: Lane(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                name: numToDay[element.day].substring(0, 3).toUpperCase() ??
                    'N/A',
                width: (width / 8),
                textStyle: TextStyle(color: Colors.brown, fontSize: 10)),
            events: PeriodBuilder(element)));
      });
      return list;
    } else {
      return ScheduleHeader(width: width, context: context);
    }
  }

  edit(int day, String id, String title, int hourStart, int minStart,
      int hourFinish, int minFinish) {
    Get.to(() => editSchedForm(
        day, id, title, hourStart, minStart, hourFinish, minFinish, _refresh));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: rcAppBarActions(text: "Schedule", actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          iconSize: 15,
          onPressed: _refresh,
        )
      ], context: context),
      body: Container(
        child: TimetableView(
            laneEventsList: _buildLaneEvents(width),
            timetableStyle: TimetableStyle(
                laneColor: Theme.of(context).scaffoldBackgroundColor,
                cornerColor: Theme.of(context).scaffoldBackgroundColor,
                timelineColor: Theme.of(context).scaffoldBackgroundColor,
                timelineItemColor: Theme.of(context).scaffoldBackgroundColor,
                mainBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                startHour: 6,
                endHour: 22,
                timeItemTextColor: Colors.brown,
                laneWidth: (width / 8),
                timeItemWidth: (width / 8))),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            add();
          }),
    );
  }
}
