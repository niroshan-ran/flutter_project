
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/samplemodels.dart';

class MyNewsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _MyNewsPageState();
  }

}

class _MyNewsPageState extends State<MyNewsPage> {

  final CollectionReference newsRef = FirebaseFirestore.instance.collection('News');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My News'),
      ),
      body: Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: StreamBuilder(
                  stream: newsRef.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
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
      ));
  }



}


