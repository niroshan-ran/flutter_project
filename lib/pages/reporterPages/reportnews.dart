import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widget/drawer.dart';

class ReportNews extends StatefulWidget{
  static const String routeName = '/reportNews';
  @override
  State<StatefulWidget> createState() {
    return _ReportNewsState();
  }

}

class _ReportNewsState extends State<ReportNews>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
            title: Text("Report New News"),
            backgroundColor: Colors.amber),
        body: Container(),

      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        child: Container(
          margin: EdgeInsets.only(left: 50.0,right: 50.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_today),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {  },
              ),

              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {  },
              ),

            ],
          ),
        ),
      ),
    );
  }

}