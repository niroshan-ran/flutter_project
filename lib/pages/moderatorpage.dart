import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/admin_drawer.dart';

import 'news_management_admin.dart';


class ModeratorPage extends StatefulWidget {
  final nickName;
  final email;

  static const String routeName = '/userManagement';

  const ModeratorPage({Key? key, @required this.nickName,@required this.email}) : super(key: key);

  @override
  _ModeratorPageState createState() => _ModeratorPageState();
}

class _ModeratorPageState extends State<ModeratorPage> {
 final CollectionReference userRef = FirebaseFirestore.instance.collection('users');

 navigateToUserMng(){
   Navigator.of(context).pop();
   Navigator.of(context).push(
       PageRouteBuilder(pageBuilder: (context, _, __) {
         return ModeratorPage(nickName:widget.nickName,email : widget.email);
       }
   ));
 }

 navigateToNewAdmin(){
   Navigator.of(context).pop();
   Navigator.of(context).push(
       PageRouteBuilder(pageBuilder: (context, _, __) {
         return new NewsManagementAdminPage(nickName:widget.nickName,email : widget.email);
       }
   ));
 }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

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
                    stream: userRef.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                          var doc = snapshot.data!.docs[index].data();
                          doc : (doc as Map)["doc"].toString();
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                title: Text(doc['nickName']),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc['email']),
                                    Text(doc['position'],style: TextStyle(color: Colors.black38),),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete,color: Colors.red,),
                                  onPressed: (){deleteUser(snapshot: snapshot,index: index);},
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
