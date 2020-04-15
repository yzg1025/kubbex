import 'package:Kkubex/model/area_code.dart';
import 'package:Kkubex/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:Kkubex/util/network_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCode extends StatefulWidget {
  SelectCode({Key key}) : super(key: key);

  @override
  _SelectCodeState createState() => _SelectCodeState();
}

class _SelectCodeState extends State<SelectCode> {

  var items = []; 

  @override
  void initState() {
    super.initState();
    _getcode();
  }
  
   _getcode() async{
    AreaCode res = await UserAPI.getCountries(context: context);
    setState(() { items = res.data;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title:Text('选择国家',style: TextStyle(color:Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,), 
          onPressed:(){
            Navigator.pop(context);
          }),
      ),
      body: Container(
        child:Column(
          children:<Widget>[
            Container(
              margin: EdgeInsets.all(20),
              color:Color(0xffF9FBFF),
              height: ScreenUtil().setHeight(100),
              child:TextField(
                decoration: InputDecoration(
                  border:InputBorder.none,
                  hintText: "搜索",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 1.0, color: Color(0xffE6EDF9));
                },
                itemBuilder:  (BuildContext context,int index){
                  return Container(
                    height: ScreenUtil().setHeight(100),
                    margin: EdgeInsets.symmetric(horizontal:20),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        Text(items[index].nameChinese),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context,items[index].phoneCode);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            height: ScreenUtil().setHeight(100),
                            width: ScreenUtil().setWidth(500),
                            child:Text('+' + items[index].phoneCode.toString())
                          ),
                        )
                      ]
                    )
                  );
                },
                itemCount: items.length,
              ),
            )
          ]
        )
      ),
    );
  }
}