import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:remcards/pages/components/remcard.dart';
import '../edit_card.dart';


//============ values ================================
Map<int,Icon> iconMap = {
  0:Icon(Icons.adjust_rounded, color: Colors.white),
  1:Icon(Icons.double_arrow_rounded, color: Colors.white),
  2:Icon(Icons.history_toggle_off_rounded, color: Colors.white),
  3:Icon(Icons.stars_rounded, color: Colors.white),
  4:Icon(Icons.check_circle_rounded, color: Colors.white)};

Map<int,String> statusMap = {
  0:"Not yet started",
  1:"Started",
  2:"Ongoing",
  3:"Needs Attention",
  4:"Finished"};

Map<int,Color> color = {
  0: Color(0xFF2980b9),
  1: Color(0xFFf1c40f),
  2: Color(0xFFe74c3c),
};

Widget RCard({RemCard remcard, BuildContext context, Function deleteCard, Function refresh, Function incrementStatus}) {
    remcard.tskstat = remcard.tskstat % 5;
    _delete() async {
      await deleteCard(remcard.id);
      refresh();
    }

    _incstat() async{
      await incrementStatus(remcard.id, remcard.tskstat);
      refresh();
    }
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>  _delete(),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Theme.of(context).textTheme.bodyText1.color,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Card(
        elevation: 2,
        child: InkWell(
            child: ClipPath(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(remcard.tskdesc,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context).textTheme.bodyText1.color,
                                    fontWeight: FontWeight.w700)),
                            Text(remcard.subjcode,
                                style: TextStyle(fontFamily: 'Montserrat',color: Theme.of(context).textTheme.bodyText1.color)),
                            Text(remcard.tskdate,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context).textTheme.bodyText1.color,
                                    fontWeight: FontWeight.w300))
                          ],
                        ),
                      ),
                      SizedBox(width: 8,),
                      ElevatedButton(
                        onPressed: ()=>_incstat(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.5, vertical: 1),
                          child: Row(
                            children: [
                              iconMap[remcard.tskstat]??Icon(Icons.adjust_rounded, color: Colors.white),
                              SizedBox(width: 3,),
                              Text(statusMap[remcard.tskstat]??"Not yet started"),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)),
                          padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              color[remcard.tsklvl]??Color(0xFF2980b9)), // <-- Button color
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  )),
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editCardForm(
                        remcard: remcard,
                        refresh: refresh),
                  ));
            }),
      ),
    );
  }