import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_project/pages/reporterPages/reportnews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class UploadPhotoPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }

}

class _UploadPhotoPageState extends State<UploadPhotoPage>{


  late final File sampleImage;
  late final String _myValue;
  late final String url;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getImage().whenComplete(() {
      setState(() {});
    });
  }

  Future getImage() async{
    final tempImage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (tempImage != null) {
        sampleImage = File(tempImage.path);
      }else{
        print('No image selected.');
      }
    });
  }

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }


  void uploadStatusImage() async {
    if(validateAndSave()){
      final Reference Ref = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = new DateTime.now();

      final UploadTask uploadTask = Ref.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      url = imageUrl.toString();
      print("Image Url :" + url);

      goToHome();
      saveToDB(url);
    }
  }

  void saveToDB(url){
    var dbTimeKey = new DateTime.now();
    var formatDate= new DateFormat("MMM d, yyyy");
    var formatTime= new DateFormat("EEEE, hh:mm, aaa");

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    // DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    CollectionReference newsDataRef = FirebaseFirestore.instance.collection('News');

    var data = {
      "title": "test title",
      "image": url,
      "description": _myValue,
      "isPublish": false,
      "date": date,
      "time": time,
    };

    newsDataRef.add(data);

    // dbRef.child("News").push().set(data);
  }


  void goToHome(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return new ReportNews();
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),

      body: Center(
        child: sampleImage==null? Text("Select an Image"): enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }


  Widget enableUpload(){
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(sampleImage, height: 330.0,width: 600.0,),
            SizedBox(height: 15.0,),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Description'),
              validator: (value){
                return value!.isEmpty ? 'Description is Required' : null;
              },
              onSaved: (value){
                _myValue = value!;
              },
            ),
            SizedBox(height: 15.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                onPrimary: Colors.white,
              ),
              onPressed: uploadStatusImage,
              child: Text("Add a New Post"),

            )
          ],
        ),
      ),
    );
  }

}