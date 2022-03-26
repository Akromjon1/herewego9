import 'package:flutter/material.dart';
import 'package:hererwego/model/post_model.dart';
import 'package:hererwego/services/pref_services.dart';
import 'package:hererwego/services/rtdb_services.dart';


class DetailPage extends StatefulWidget {
  static const String id = 'detail_page';
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var contentController = TextEditingController();
  var dateController = TextEditingController();

  _addPost() async{
    String firstName  = firstNameController.text.toString();
    String lastName  = lastNameController.text.toString();
    String content = contentController.text.toString();
    String date = dateController.text.toString();
    if(firstName.isEmpty || content.isEmpty || lastName.isEmpty || date.isEmpty) return;
    _apiAddPost(firstName,lastName, content, date);
  }
  _apiAddPost(String firstName, String lastName, String content, String date) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id!, firstName, lastName, content, date)).then((response)=>{
      _respAddPost(),
    }
    );
  }
  _respAddPost(){
    Navigator.of(context).pop({'data':'done'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Text("Add Post"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: 15,),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: "First name",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: "last name",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: "Content",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  hintText: "Date",
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 45,
                child: FlatButton(
                  onPressed: _addPost,
                  color: Colors.deepOrange,
                  child: Text(
                    "Add",style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
