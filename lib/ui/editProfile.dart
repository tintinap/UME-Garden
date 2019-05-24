import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/ui/home.dart';
import 'dart:async';
//Image Plugin
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'package:firebase_storage/firebase_storage.dart';
final _formKey = GlobalKey<FormState>();

class EditProfile extends StatefulWidget {
  final String user;
  final String name;
  EditProfile(
    {
      Key key, this.user, this.name
    }
  )
    : super(key: key);
  @override
  EditProfileState createState() {
    return EditProfileState();
  }

}

File sampleImage;
class EditProfileState extends State<EditProfile> {
  
static getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(tempImage != null){
      sampleImage = tempImage;
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body:Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _editform(context,widget.user,widget.name),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _editform(context,String picture, String picturen) {
  return Padding(
    padding: EdgeInsets.all(25),
    child: Column(
      children: <Widget>[
        _btn_all(context, picture),
        _profile(picturen),
        //_username(),
        enableUpload(),
      ],
    ),
  );
}

Widget _btn_all(context, picture) {
  return Row(
    children: <Widget>[
      _btn_cancel(context),
      _btn_save(picture, context),
    ],
  );
}

Widget _btn_save(picture, context) {
  return Container(
    margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
    child: FlatButton(
      child: Text("save"),
      onPressed: () async{
        print(picture);
        try{
          final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('$picture');
          final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
          await Navigator.pushNamed(context, '/auth');
          }
        catch(e){
          print(e);
        }
        
      },
      textColor: Colors.blue,
    ),
  );
}

Widget _btn_cancel(context) {
  return Container(
    
    child: FlatButton(
      child: Text("cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Colors.blue,
        ),
      alignment: Alignment.topLeft,
  );
}

Widget _username() {
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            hintText: 'champ tid hee',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
        ),
      ],
    ),
  );
}

Widget _profile(picture){
  return new Hero(
    tag: 'profile',
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 5.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120.0,
        child: ClipOval(
          child: Image.network(picture),
        ),
      ),
    ),
  );
}

Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.black,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.black)),
            onPressed: () {
              EditProfileState.getImage();    
            },
          )
        ],
      ),
    );
  }