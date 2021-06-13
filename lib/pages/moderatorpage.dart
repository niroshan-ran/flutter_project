import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ModeratorPage extends StatefulWidget {
  final nickName;
  final email;

  const ModeratorPage({Key? key, @required this.nickName,@required this.email}) : super(key: key);

  @override
  _ModeratorPageState createState() => _ModeratorPageState();
}

class _ModeratorPageState extends State<ModeratorPage> {

 final CollectionReference userRef = FirebaseFirestore.instance.collection('users');

 navigateToUserMng(){
   return ModeratorPage(nickName:widget.nickName,email : widget.email);
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
        appBar: AppBar(title: Text("Moderator Page")),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text('${widget.nickName}'),
                  accountEmail: Text('${widget.email}'),
                  currentAccountPicture: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(image: AssetImage("assets/admin_avatar.png"))
                    ),
                  ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Users"),
                onTap: navigateToUserMng,
              ),
              ListTile(
                leading: Icon(Icons.pages),
                title: Text("Articles"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Log Out"),
                onTap: signOut,
              )
            ],
          ),
        ),
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
