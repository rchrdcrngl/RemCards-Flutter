import 'dart:async';
import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remcards/const.dart';
import 'package:remcards/pages/components/card.dart';
import 'package:remcards/pages/components/request_header.dart';
import 'package:remcards/pages/components/session_handler.dart';
import 'package:remcards/pages/components/card_functions.dart';
import 'package:remcards/pages/login.dart';
import 'add_card.dart';
import 'components/app_bar.dart';
import 'components/remcard.dart';
import 'components/utils.dart';


//======================= builder ===========
class CardBuilder extends StatefulWidget {
  final bool isRefresh;

  const CardBuilder({Key key, this.isRefresh = false}) : super(key: key);

  static _CardBuilderState of(BuildContext context) =>
      context.findAncestorStateOfType<_CardBuilderState>();
  @override
  _CardBuilderState createState() => new _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  Future<List<RemCard>> data;
  bool isUpdated = false;
  bool fetchError = false;
  bool unauthorized = false;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;

  @override
  void initState(){
    super.initState();
    data = fetchData();
  }

  Future<List<RemCard>> fetchData([howMany = 5]) async {
    var cacheExists = await APICacheManager().isAPICacheKeyExist("API-Cards");
    if (!cacheExists) {
      final headers = await getRequestHeaders();
      final response = await http.get(Uri.parse(cardsURI), headers: headers);

      if (response.statusCode == 200) {
        APICacheDBModel cacheDBModel =
        new APICacheDBModel(key: "API-Cards", syncData: response.body);

        await APICacheManager().addCacheData(cacheDBModel);

        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((card) => new RemCard.fromJson(card)).toList();
      } else if (response.statusCode == 401) {
        invalidateSession();
        setState(() {
          unauthorized = true;
        });
      } else {
        setState(() {
          fetchError = true;
        });
        throw Exception('Failed to load RemCards');
      }
      return [];
    }
    var cacheData = await APICacheManager().getCacheData("API-Cards");
    List jsonResponse = json.decode(cacheData.syncData);
    return jsonResponse.map((card) => new RemCard.fromJson(card)).toList();
  }


  parseData() async {
    fetchData().then((res) async {
      return res;
    });
  }

  showSnack(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  refresh() => _refresh();

  void _refresh() {
    APICacheManager().deleteCache("API-Cards");
    setState(() {
      data = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: rcAppBarActions(text:"All RemCards",actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            iconSize: 15,
            onPressed: (){
              showToast(message:'Refreshing RemCards');
              _refresh();
            },
          )
        ],context: context),
        key: scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: ()=>Get.to(()=>AddCardForm(refresh: refresh,)),
          child: Icon(Icons.add),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: FutureBuilder<List<RemCard>>(
            future: data,
            builder: (context, snapshot) {
              if ((snapshot.hasData) && ((snapshot.data).isEmpty)) {
                return Center(
                    child: Text(
                        "You have no RemCards yet. Start by adding one!",
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(fontFamily: 'Montserrat')));
              } else if (snapshot.hasData) {
                List<RemCard> data = snapshot.data;
                return _cardBuilder(data);
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text("${snapshot.error}"));
              } else if (fetchError) {
                return Center(
                    child: Text("Can't load RemCards at the moment."));
              } else if (unauthorized) {
                print("unauthorized!");
                Get.snackbar("Unauthorized", "Try logging back in...");
                Get.offAll(LoginPage());
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }



  ListView _cardBuilder(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return RCard(
            remcard: data[index],
            deleteCard: deleteCard,
            refresh: refresh,
            incrementStatus: incrementStatus,
            context: context,
          );
        });
  }
}
