import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin_drawer.dart';
import 'moderatorpage.dart';


class NewsManagementAdminPage extends StatefulWidget {
  final nickName;
  final email;
  static const String routeName = '/newsManagement';

  const NewsManagementAdminPage({Key? key, @required this.nickName,@required this.email}) : super(key: key);

  @override
  _NewsManagementAdminPageState createState() => _NewsManagementAdminPageState();
}

class _NewsManagementAdminPageState extends State<NewsManagementAdminPage> {

  final CollectionReference newsRef = FirebaseFirestore.instance.collection('guest_news');

  navigateToUserMng(){
    return ModeratorPage(nickName:widget.nickName,email : widget.email);
  }

  navigateToNewAdmin(){
    return NewsManagementAdminPage(nickName:widget.nickName,email : widget.email);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  rejectArticle({required AsyncSnapshot<QuerySnapshot<Object?>> snapshot, required int index}){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Reject Article'),
            content: Text('Are you sure you want to reject ?'),
            actions: [
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
              ElevatedButton(
                  onPressed: (){
                    snapshot.data!.docs[index].reference
                        .update({
                          "isPublish" : false
                        }).whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Reject')
              )
            ],
          );
        }
    );
  }

  approveArticle({required AsyncSnapshot<QuerySnapshot<Object?>> snapshot, required int index}){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Approve Article'),
            content: Text('Are you sure you want to Approve ?'),
            actions: [
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
              ElevatedButton(
                  onPressed: (){
                    snapshot.data!.docs[index].reference
                        .update({
                      "isPublish" : false
                    }).whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Approve')
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("News Admin")),
        drawer: AdminDrawer(nickName: widget.nickName,email: widget.email,),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  title: Center(child: Text(doc['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,),)),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Image.network(
                                        doc['image'],
                                        height: 150,
                                        width: 300,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(doc['description'],style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic),),
                                      SizedBox(height: 6,),
                                      Text(doc['isPublished'] == true ?'Active':'Deactive',style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(doc['nickName'],style: TextStyle(color: Colors.black38,fontStyle: FontStyle.italic,),),
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: (){
                                                approveArticle(snapshot: snapshot,index: index);
                                              },
                                              icon: Icon(Icons.done_all,color: Colors.green,size: 40,)),
                                          IconButton(
                                              onPressed: (){
                                                rejectArticle(snapshot: snapshot,index: index);
                                              },
                                              icon: Icon(Icons.block,color: Colors.red,size: 40,))
                                        ],
                                      )
                                    ],
                                  ),
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
