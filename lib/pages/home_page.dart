import 'package:flutter/material.dart';
import 'package:hererwego/model/post_model.dart';
import 'package:hererwego/services/auth_services.dart';
import 'package:hererwego/services/pref_services.dart';
import 'package:hererwego/services/rtdb_services.dart';

import 'detail_page.dart';
class HomePage extends StatefulWidget {
  static final String id = "home_page";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPost();
  }
  Future _openDetail() async {
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context){
          return new DetailPage();
        }
    ));
    if(results != null && results.containsKey('data')){
      print(results["data"]);
      _apiGetPost();
    }
  }
  _apiGetPost() async{
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts)=>{
      _respPosts(posts),
    });
  }
  _respPosts(List<Post> posts){
    setState(() {
      items = posts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              AuthService.SignOutUser(context);
            },
            icon: Icon(Icons.exit_to_app),)
        ],
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: Text("All Posts"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          return itemOfList(items[i]);
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _openDetail();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
  Widget itemOfList(Post post){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(post.firstName!, style: TextStyle(color: Colors.black, fontSize: 20),),
              SizedBox(width: 10,),
              Text(post.lastName!, style: TextStyle(color: Colors.black, fontSize: 20),),
            ],
          ),
          SizedBox(height: 10,),
          Text(post.date!, style: TextStyle(color: Colors.grey, fontSize: 16),),
          SizedBox(height: 10,),
          Text(post.content!, style: TextStyle(color: Colors.grey, fontSize: 16),),
        ],
      ),

    );
  }
}