import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:remcards/pages/card_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'components/remcards_nav_bar.dart';
import 'pages/Login.dart';
import 'pages/Schedule.dart';
import 'pages/Settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      defaultColor: Colors.teal,
      importance: NotificationImportance.Default,
      channelShowBadge: true, channelDescription: 'Allows RemCard to be on the basic notification channel',
    ),
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      defaultColor: Colors.teal,
      importance: NotificationImportance.Default, channelDescription: 'Allows RemCard to create scheduled notifications',
    )
  ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    print("Notif Allowed?: " + isAllowed.toString());
    if (!isAllowed)
      AwesomeNotifications().requestPermissionToSendNotifications();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RemCards",
      darkTheme: ThemeData(
        bottomAppBarColor: Color(0xFF21334a),
        primaryColor: Color(0xFF385880),
        backgroundColor: Color(0xFF4a607d),
        unselectedWidgetColor: Color(0xff788eaa),
        scaffoldBackgroundColor: Color(0xff0b1a2c),
        cardTheme: CardTheme(color: Color(0xFF4a607d)),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700,color: Colors.white),
          bodyText1: TextStyle(fontSize: 12.0,color: Colors.white),
        ),
      ),
      theme: ThemeData(
        bottomAppBarColor: Color(0xFF21334a),
        primaryColor: Color(0xFF385880),
        backgroundColor: Color(0xFF4a607d),
        unselectedWidgetColor: Color(0xff788eaa),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700,color: Colors.black),
          bodyText1: TextStyle(fontSize: 12.0,color: Colors.black),
        ),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int pageIdx;
  final bool cRef;
  final bool sRef;

  const MainPage(
      {Key key, this.pageIdx = 0, this.cRef = false, this.sRef = false})
      : super(key: key);

  static _MainPageState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainPageState>();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginStatus();
    if (widget.cRef) cardsRefresh();
    if (widget.sRef) schedRefresh();
    returnAt(widget.pageIdx);

    //NOTIFICATION


    //Set Pages
    _widgetOptions = <Widget>[
      CardBuilder(),
      SchedulePage(),
      Settings(),
    ];
  }

  returnAt(int idx) {
    _onItemTapped(idx);
  }

  cardsRefresh() {
    setState(() {
      _widgetOptions[0] = CardBuilder(isRefresh: true);
    });
    print("MAIN: CARDS_REFRESH");
  }

  schedRefresh() {
    setState(() {
      _widgetOptions[1] = SchedulePage(isRefresh: true);
    });
    print("MAIN: SCHEDULE_REFRESH");
  }

  loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Get.offAll(()=>LoginPage());
    }
  }

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: RemCardsNavBar(onTap: (idx) { _onItemTapped(idx); },
    children: [
      RemCardsNavBarImageButton(title: 'RemCards', assetURL: 'assets/icon/icon.png'),
      RemCardsNavBarIconButton(title: 'Schedule', icon: const Icon(Icons.calendar_today_outlined)),
      RemCardsNavBarIconButton(title: 'Settings', icon: const Icon(Icons.settings)),
    ]),
    );
  }
}
