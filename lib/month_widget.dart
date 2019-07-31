import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MonthWidget extends StatefulWidget{
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  MonthWidget({Key key, this.documents}) : 
  total = documents.map((doc) => doc['value'])
    .fold(0.0, (a, b) => a + b),
  perDay = List.generate(30, (int index){
    return documents.where((doc) => doc['day'] == (index + 1))
    .map((doc) => doc['value'])
    .fold(0.0, (a, b) => a+b);
  }),
  categories = documents.fold({}, (Map<String, double> map, document){
    if (!map.containsKey(document['category'])){
      map[document['category']] = 0.0;
    }
    map[document['category']] += document['value'];
    return map;
  }),
  super(key: key);
  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget>{
  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Column(
        children: <Widget>[
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueGrey.withOpacity(0.1),
            height: 20.0,
          ),
          _list(),
      ],),);
  }
  Widget _expenses(){
    return Column(
      children: <Widget>[
        Text("\$ ${widget.total.toStringAsFixed(2)} ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            color: Colors.blueAccent,
            ),),
        Text("Gastos Totales",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.grey,
            ),),
      ],
    );
  }
  Widget _graph() => Container();
  Widget _item(IconData icon, String name, int percent, double value){
    return ListTile(
      leading: Icon(icon, size: 32.0,),
      title: Text(name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
          ),),
      subtitle: Text("$percent% de los gastos",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey
          ),),
      trailing: Text("\$$value",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold
          ), ),
    );
  }
  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext contex, int index){
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _item(FontAwesomeIcons.shoppingCart, key, 100 * data~/widget.total, data);
          },
        separatorBuilder: (BuildContext context, int index){
          return Container(
            height: 8.0,
          );
        },
        ),);
  }
}