import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/reporterPages/myNewsList.dart';
import 'package:flutter_project/pages/reporterPages/newsfeed.dart';
import 'package:flutter_project/pages/reporterPages/photoupload.dart';
import 'package:flutter_project/widget/drawer.dart';

class ReportNews extends StatefulWidget{
  static const String routeName = '/reportNews';
  @override
  State<StatefulWidget> createState() {
    return _ReportNewsState();
  }

}

// ignore: non_constant_identifier_names
Widget NewsArray(BuildContext context){

  final CollectionReference newsRef = FirebaseFirestore.instance.collection('News');

  deleteUser({required AsyncSnapshot<QuerySnapshot<Object?>> snapshot, required int index}){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Delete User'),
            content: Text('Are you sure you want to delete ?'),
            actions: [
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
              ElevatedButton(
                  onPressed: (){
                    snapshot.data!.docs[index].reference.delete().whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete')
              )
            ],
          );
        }
    );
  }

  return Container(
    color: Colors.black12,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: StreamBuilder(
              stream: newsRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context,index){
                      var doc = snapshot.data!.docs[index].data();
                      doc : (doc as Map)["doc"].toString();
                      return Card(
                        margin: EdgeInsets.all(15.0),
                        elevation: 10,
                        child: Container(
                          padding: new EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      doc['date'],
                                      style: Theme.of(context).textTheme.subtitle1,
                                      textAlign: TextAlign.center),
                                  Text(
                                      doc['time'],
                                      style: Theme.of(context).textTheme.subtitle1,
                                      textAlign: TextAlign.center),
                                ],
                              ),

                              SizedBox(height: 10,),

                              Image.network(
                                doc['image'],
                                fit: BoxFit.cover,
                              ),

                              SizedBox(height: 10,),

                              Text(
                                  doc['description'],
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.center),
                              Container(
                                child: Row(
                                  children: [
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.delete,color: Colors.black,),
                                      onPressed: (){deleteUser(snapshot: snapshot,index: index);},
                                    )
                                  ],
                                ),
                              )

                            ],

                          ),
                        ),
                      );
                    }
                );
              },
            )
        )
      ]),
    ),
  );
}

class _ReportNewsState extends State<ReportNews>{

  final CollectionReference newsRef = FirebaseFirestore.instance.collection('News');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
            title: Text("Report New News"),
            backgroundColor: Colors.amber),
        body: NewsArray(context),

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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ReportNews();
                  }));
                },
              ),

              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return new UploadPhotoPage();
                  }));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

}