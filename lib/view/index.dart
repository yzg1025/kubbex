import 'package:Kkubex/model/notic.dart';
import 'package:Kkubex/util/network_utils.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
 
 @override
 void initState() { 
   super.initState(); 
 }
  // getUrl() async{
  //   Future<Notice> res =HttpUtil.getNotice(context) ;
  //   print(res);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:Text('....')
      ),
    );
  }
}