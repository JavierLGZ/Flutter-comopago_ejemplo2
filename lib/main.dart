import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comogasto_fp2/month_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  int currentPage = 9;
  Stream<QuerySnapshot> _query;

  @override
  void initState(){
    super.initState();

    _query = Firestore.instance
      .collection('expenses')
      .where('month', isEqualTo: currentPage +1)
      .snapshots();

    _controller=PageController(
      initialPage: currentPage, //pagina inicial,
      viewportFraction: 0.3,
    );
  }

  Widget _bottomAction(IconData icon){
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: (){},
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            _bottomAction(FontAwesomeIcons.chartPie),
            SizedBox(width: 32.0),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(Icons.settings),
          ],),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if (data.hasData){
                return MonthWidget(
                  documents: data.data.documents);
              }
              return Center(
                child: CircularProgressIndicator(),);            
          },),
          
        ],),);
  }
  Widget _pageItem(String name, int pos){
    var _aligment;
    final selected = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Colors.black
      );
    final unselected = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 15.0,
      color: Colors.grey
      );
    if (pos == currentPage){
      _aligment = Alignment.center;
    }else if(pos < currentPage){
      _aligment = Alignment.centerLeft;
    }else{
      _aligment = Alignment.centerRight;
    }
    return Align(
      alignment: _aligment,
      child: Text(name,
        style: pos == currentPage ? selected : unselected,
      ),);
  }
  Widget _selector(){
    return SizedBox.fromSize(
      size: Size.fromHeight(50.0),
      child: PageView(
        onPageChanged: (newPage){
          setState(() {
            currentPage = newPage;
            _query = Firestore.instance
              .collection('expenses')
              .where('month', isEqualTo: currentPage +1)
              .snapshots();
            });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero",0),
          _pageItem("Febrero",1),
          _pageItem("Marzo",2),
          _pageItem("Abril",3),
          _pageItem("Mayo",4),
          _pageItem("Junio",5),
          _pageItem("Julio",6),
          _pageItem("Agosto",7),
          _pageItem("Septiembre",8),
          _pageItem("Octubre",9),
          _pageItem("Novimbre",10),
          _pageItem("Diciembre",11),
    ],),);
  }
}
