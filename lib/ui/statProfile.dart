import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'statDistances.dart';
import '../globals.dart' as globals;


class StatProfile extends StatefulWidget {
  final String user;

  StatProfile({Key key, this.user}): super(key: key);
  @override
  StatProfileState createState() {
    return StatProfileState();
  }

}


class StatProfileState extends State<StatProfile> {
  Firestore _store = Firestore.instance;
  List allDate = [];
  int countDoc = 0;
  String totalKm;
  int tree;

  // นับจำนวน document ใน firestore เพื่อทำ loop
  Future _countDocuments() async {
    await _store.collection('register2').document(widget.user).collection('date').getDocuments().then((doc){
      setState(() {
        countDoc = doc.documents.length;
      });
      doc.documents.forEach((doc) {
        allDate.add(doc.data['date']);
      });
    });
  }

  void _getData() async {
    List<Map> current = await globals.gp.db.rawQuery("select * from Guest");
    totalKm = current[0]['totalKm'];
    tree = current[0]['tree'];
  }

  @override
  Widget build(BuildContext context) {
    _countDocuments();
    _getData();
    return Scaffold(
      appBar: AppBar(
        title: Text("User Stat"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _profile_container(context, widget.user),
              _tree(tree, totalKm),
              allDate.length==0 ?
              Center(child: Text('No data...'))
              : Container(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: countDoc,
                    itemBuilder: (context, index) =>
                        _card(context, allDate, index, widget.user),
                  ),
                ),
            ]
          ),
        ),
      ),
    );
  }
}

Widget _profile_container(context, name){
  return Container(
    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
    color: Colors.teal,
    height: 130.0,
    child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
         _profile(),
         _name(name),
      ],
    ),
  );
}

Widget _profile(){
  return new Hero(
    tag: 'profile',
    child: Container(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 40,
        child: Image.asset('assets/guest.png'),
      ),
    ),
  ); 
}

Widget _name(name){
  return Container(
    child: Text(
      '$name',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: Colors.white
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _tree(tree, km){
  return Container(
    padding: EdgeInsets.all(30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("จำนวนต้นไม้", textAlign: TextAlign.left, style: TextStyle(fontSize: 14.0, color: Colors.teal)),
              Text("$tree ต้น", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.left,),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(135, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text("ระยะทางรวม", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.0, color: Colors.teal)),
              Text("$km กิโลเมตร", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.right,),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _btn_stat(context){
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: RaisedButton(
      child: Text("บันทึกสถิติ",
        style: new TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/stat');
      },
      splashColor: Colors.grey,
      textColor: Colors.blueGrey,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}

Widget _card(BuildContext context, allDate, index, user) {
  return Container(
    margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
    child: Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StatScreen(
            date: allDate[index], user: user)));
            print('tabbed');
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(20.0),
          title: Text(allDate[index],
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
          ),
        ),  
      ),
    )
  );
}