import 'dart:async';

import 'package:Kkubex/model/login.dart';
import 'package:Kkubex/model/registermodel.dart';
import 'package:Kkubex/tools/validator.dart';
import 'package:Kkubex/util/navigator_util.dart';
import 'package:Kkubex/util/network_utils.dart';
import 'package:Kkubex/view/login_reg_forget/select_code.dart';
import 'package:Kkubex/widget/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

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
                    NavigatorUtil.goLoginPage(context);
                  },
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                )
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
            child:RegisterFromPage()
          )
        ]
      )
    );
  }
}


class RegisterFromPage extends StatefulWidget {
  @override
  _RegisterFromPageState createState() => _RegisterFromPageState();
}

class _RegisterFromPageState extends State<RegisterFromPage> with SingleTickerProviderStateMixin {
  TabController controller;

  Timer _timer;
  var countdownTime = 0;  //倒计时数

  final TextEditingController _phoneController = TextEditingController(); // phone的控制器 
  final TextEditingController _emailController = TextEditingController(); // email的控制器
  final TextEditingController _passwordController = TextEditingController(); // 密码的控制器
  final TextEditingController _repasswordController = TextEditingController(); // 确认密码的控制器
  final TextEditingController _codeController = TextEditingController(); // email的控制器

  String areacode = '86';
  String codeType = '请输入手机验证码';
  RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
  bool index = false;
  bool obscureText = true;

  var tabs = <Tab>[];

  @override
  void initState() {
    super.initState();
     
    tabs = <Tab>[
      Tab(text: "手机找回",),
      Tab(text: "邮箱找回",),
    ];
    controller = TabController(length: tabs.length, vsync: this);
    controller.addListener((){
      controller.index == 0 ? codeType = "请输入手机验证码" : codeType ='请输入邮箱验证码';
      setState(() {});
    });

    _emailController.addListener((){
      if (!duIsEmail(_emailController.value.text)) {
        return Utils.showToast('邮箱格式不正确');
      }
    });

  }
  
  changePassType(){
    index = !index;
    obscureText = !obscureText;
    setState(() {});
  }

  //倒计时方法
  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }
  //忘记密码
  _foundPass() async{
    if(_phoneController.value.text == '') return Utils.showToast('手机号格式不正确');
    Login params = Login(
      is_debug: true,
      accounttype:controller.index+1 == 1 ? 1 : 2,
      account:controller.index+1 == 1 ? areacode + _phoneController.value.text : _emailController.value.text,
      password: _passwordController.value.text,
      repassword: _repasswordController.value.text,
      code:_codeController.value.text
    );

    GetCodeResponse message = await UserAPI.getForgetPass(
      context: context,
      params: params,
    );
    if (message.code == 400) {
      Utils.showToast(message.message);
    }else{
      Utils.showToast('找回成功');
      NavigatorUtil.goLoginPage(context);
    }
  }

  //获取验证码
  _getCode() async{
    //if(_phoneController.value.text == '') return Utils.showToast('账号格式不正确');
    GetCodeRequire params = GetCodeRequire(
      is_debug: true,
      accounttype:controller.index+1 == 1 ? 1 : 2,
      account:controller.index+1 == 1 ? areacode + _phoneController.value.text : _emailController.value.text,
    );

    GetCodeResponse message = await UserAPI.getCode(
      context: context,
      params: params,
    );
    Utils.showToast(message.toString());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _repasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
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
              controller: _passwordController,
              decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                hintText: "请输入新的密码",
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
          //确认密码
          Container(
            decoration: bottomBorder,
            child: TextField(
              controller: _repasswordController,
              decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                hintText: "请确认密码",
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
              controller: _codeController,
              decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                hintText: codeType,
                prefixIcon: Image.asset('image/icon_safe.png',),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child:Container(
                    width:100,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:Color(0xffF3F8FF),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child:InkWell(
                      onTap: (){
                        if (countdownTime == 0) {
                          startCountdown();
                          _getCode();
                        }
                      },
                      child:Text(
                        countdownTime>0?"还剩${countdownTime}s":"验证码",
                        style: TextStyle(fontSize:17,color:countdownTime>0 ? Colors.black : Color(0xff287DFD)),
                      )
                    )
                  )
                )
              ),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top:60),
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
                _foundPass()();
              },
              child:Text('确认',style:TextStyle(fontSize:20,color:Colors.white)),
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
      padding: EdgeInsets.only(bottom:10),
      child: TextField(
        controller: _phoneController,
        decoration: InputDecoration(
          border:InputBorder.none,
          hintText: "请输入手机号",
          prefixIcon: Container(
            width: 60,
            child:InkWell(
              onTap: (){
                _navigateCode(context);
              },
              child:Row(
                children:<Widget>[
                  Text('+$areacode',style: TextStyle(color: commonColor)),
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
        controller: _emailController,
        decoration: InputDecoration(
          border:InputBorder.none,
          hintText: "请输入邮箱账号",
          prefixIcon: Image.asset('image/icon_email.png',),
        ),
      ),
    );
  }

  _navigateCode(BuildContext context) async{ //async是启用异步方法
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectCode()));
    setState(() {areacode =result.toString();});
  }
}