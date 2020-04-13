import 'dart:io';

import 'package:Kkubex/model/area_code.dart';
import 'package:Kkubex/model/notic.dart';
import 'package:Kkubex/util/navigator_util.dart';
import 'package:Kkubex/util/network_utils.dart';
import 'package:Kkubex/widget/future_builder.dart';
import 'package:Kkubex/widget/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Stack(
        children:<Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset('image/background.png',fit: BoxFit.cover,)
          ),
          Positioned(
            top: 50,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                InkWell(
                  onTap:(){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                ),
                InkWell(
                  onTap:(){
                    Navigator.of(context).pop();
                  },
                  child: Text('注册',style:TextStyle(color:Colors.white,fontSize: 18)),
                ),
              ]
            ),
          ),
          Positioned(
            top:100,
            left:180,
            child:Image.asset('image/logo.png',fit: BoxFit.cover,)
          ),
          Positioned(
            top:300,
            left:50,
            right:50,
            child:FromPage()
          )
        ]
      )
    );
  }
}


class FromPage extends StatefulWidget {
  @override
  _FromPageState createState() => _FromPageState();
}

class _FromPageState extends State<FromPage> with SingleTickerProviderStateMixin {
  TabController controller;

  final String areacode = '+86';
  String codeType = '请输入手机验证码';
  bool index = false;
  bool obscureText = true;
  bool cashPass = false;

  var tabs = <Tab>[];


  @override
  void initState() {
    super.initState();
     
    tabs = <Tab>[
      Tab(text: "手机登录",),
      Tab(text: "邮箱登录",),
    ];
    controller = TabController(length: tabs.length, vsync: this);
    controller.addListener((){
      controller.index == 0 ? codeType = "请输入手机验证码" : codeType ='请输入邮箱验证码';
      setState(() {});
    });
     _getcode();
  }

  _getcode(){
    UserAPI.getCountries(context: context).then((val){
      print(val.data);
    });
  }
  
  changePassType(){
    index = !index;
    obscureText = !obscureText;
    setState(() {});
  }

  remPass(){
    cashPass = !cashPass;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Column(
        children:<Widget>[
          DefaultTabController(
            length: tabs.length, 
            child: TabBar(
              controller: controller,//可以和TabBarView使用同一个TabController
              tabs: tabs,
              isScrollable: false,
              indicator:BoxDecoration(),
              labelColor: commonColor,
              labelStyle: TextStyle(fontSize: 18.0,),
              unselectedLabelColor: Color(0xffB9C3D5),
            )
          ),
          SizedBox(height: 15,),
          Expanded(
            child:TabBarView(
              controller: controller,
              children: <Widget>[
                phoneLogin(),
                emailLogin()
              ],
            )
          ),
          //密码
          Container(
            decoration: bottomBorder,
            child: TextField(
              decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                hintText: "请输入密码",
                prefixIcon: Image.asset('image/icon_password.png',),
                suffixIcon: InkWell(
                  onTap: (){
                    changePassType();
                  },
                  child:Image.asset(
                    index ? 'image/eye_on.png':'image/eye_off.png',scale: 0.65,
                  ),
                )
              ),
              obscureText: obscureText,
            ),
          ),
          //验证码
          Container(
            decoration: bottomBorder,
            child:TextField(
              decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                hintText: codeType,
                prefixIcon: Image.asset('image/icon_safe.png',),
                suffix: Container(
                  width:60,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:Color(0xffF3F8FF),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child:InkWell(
                    onTap: (){
                      print('22');
                    },
                    child:Text('验证码')
                  )
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:45),
            child: Row(
              children:<Widget>[
                InkWell(
                  onTap: (){
                    remPass();
                  },
                  child: Image.asset(
                    cashPass ? 'image/right_selected.png' :'image/right_normal.png',
                    scale: 0.8,
                  ),
                ),
                SizedBox(width: 10,),
                Text('记住密码',style: TextStyle(color:Color(0xffB9C3D5),fontSize: 16),)
              ]
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top:25),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5D9EFF), Color(0xFF287DFD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child:GestureDetector(
              onTap:(){
                NavigatorUtil.goIndexPage(context);
              },
              child:Text('登录',style:TextStyle(fontSize:20,color:Colors.white)),
            )
          ),
          Container(
            margin: EdgeInsets.only(top:70),
            child:GestureDetector(
              onTap:(){},
              child:Text('忘记密码'),
            )
          ),
        ]
      ),
    );
  }
  //手机表单
  Widget phoneLogin(){
    return Container(
      decoration: bottomBorder,
      padding: EdgeInsets.only(top:10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "请输入手机号",
          prefixIcon: Container(
            width: 60,
            child:InkWell(
              onTap: (){
                // showDialog<Null>(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (BuildContext context) {
                //     return new CupertinoAlertDialog(
                //       title: new Text('标题'),
                //       content: new SingleChildScrollView(
                       
                //       )
                //     );
                //   },
                // ).then((val) {
                //     print(val);
                // });
              },
              child:Row(
                children:<Widget>[
                  Text(areacode,style: TextStyle(color: commonColor)),
                  //SizedBox(width:5),
                  Image.asset('image/drop_down.png',scale: 0.6,)
                ]
              )
            )
          )
        ),
      ),
    );
  }
  //邮箱表单
  Widget emailLogin(){
    return Container(
      padding: EdgeInsets.only(top:10),
      decoration: bottomBorder,
      child: TextField(
        decoration: InputDecoration(
          border:InputBorder.none,
          hintText: "请输入邮箱账号",
          prefixIcon: Image.asset('image/icon_email.png',),
        ),
      ),
    );
  }
}