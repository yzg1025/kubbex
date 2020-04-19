import 'dart:async';

import 'package:Kkubex/model/registermodel.dart';
import 'package:Kkubex/util/navigator_util.dart';
import 'package:Kkubex/util/network_utils.dart';
import 'package:Kkubex/view/login_reg_forget/select_code.dart';
import 'package:Kkubex/widget/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  TabController controller;
  PageController _pageController;

  final TextEditingController _phoneController = TextEditingController(); // phone的控制器 
  final TextEditingController _emailController = TextEditingController(); // email的控制器
  final TextEditingController _passwordController = TextEditingController(); // 密码的控制器
  final TextEditingController _repasswordController = TextEditingController(); // 重复密码的控制器
  final TextEditingController _capitalpasswordController = TextEditingController(); // 资金密码的控制器
  final TextEditingController _recapitalpasswordController = TextEditingController(); // 重复资金密码的控制器
  final TextEditingController _codeController = TextEditingController(); // 验证码的控制器
  final TextEditingController _inviteController = TextEditingController(); // 邀请码的控制器

  
  final bottomBorderLine = BoxDecoration(border:Border(bottom: BorderSide(width: 2.0, color: Color(0xFFE6EDF9)),));
  String areacode = '86';
  bool cur = false;
  bool obscureText = true;
  bool cashPass=false;
  String codeType = '请输入手机验证码';

  Timer _timer;
  var countdownTime = 0;  //倒计时数

  @override
  void initState() {
    super.initState();
    controller = TabController(length:2, vsync: this);
    controller.addListener((){
      controller.index == 0 ? codeType = "请输入手机验证码" : codeType ='请输入邮箱验证码';
      setState(() {});
    });
   
    _pageController = PageController(
      initialPage: 0
    );
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

  //注册
  _register() async{
    RegisterRequire params = RegisterRequire(
      is_debug: true,
      accounttype:controller.index+1 == 1 ? 1 : 2,
      account:controller.index+1 == 1 ? areacode + _phoneController.value.text : _emailController.value.text,
      password: _passwordController.value.text,
      pay_password: _capitalpasswordController.value.text,
      code: _codeController.value.text,
      invite: _inviteController.value.text
    );
    
    GetCodeResponse message = await UserAPI.getRegister(
      context: context,
      params: params,
    );
    if (message.code == 400) {
      Utils.showToast(message.message);
    }else{
      Utils.showToast('注册成功');
      NavigatorUtil.goLoginPage(context);
    }
    
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    controller.dispose();
    _codeController.dispose();
    _pageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _inviteController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _capitalpasswordController.dispose();
    _recapitalpasswordController.dispose();
  }

  remPass(){
    cashPass = !cashPass;
    setState(() {});
  }

  changePassType(){
    cur = !cur;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff287DFD),
        title: Text('新用户注册'),
        actions: <Widget>[
          Container(
            width: ScreenUtil().setWidth(300),
            child:IconButton(
              icon: Text('已有账户?',style: TextStyle(fontSize:18),),
              onPressed: (){
                NavigatorUtil.goLoginPage(context);
              }
            )
          )
        ],
      ),
      body:Container(
        child:PageView.custom(
          controller: _pageController,
          //onPageChanged: _addPage,
          childrenDelegate: SliverChildBuilderDelegate(
          (context,index){
            if (index == 0) {
              return Column(
                children:<Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:20),
                    height: ScreenUtil().setWidth(200),
                    decoration: bottomBorderLine,
                    child:DefaultTabController(
                      length: 2, 
                      child: TabBar(
                        controller: controller,//可以和TabBarView使用同一个TabController
                        tabs: [
                          Tab(text: "手机注册",),
                          Tab(text: "邮箱注册",),
                        ],
                        isScrollable: false,
                        indicator:BoxDecoration(),
                        labelColor: commonColor,
                        labelStyle: TextStyle(fontSize: 18.0,),
                        unselectedLabelColor: Color(0xffB9C3D5),
                      )
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.symmetric(horizontal:20),
                      child:TabBarView(
                        controller: controller,
                        children: <Widget>[
                          phoneLogin(),
                          emailLogin(),
                        ],
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:40,vertical:30),
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
                        Text('注册即同意《服务协议》',style: TextStyle(color:Color(0xff414655),fontSize: 18),)
                      ]
                    ),
                  ),
                  Container(
                    width: 750,
                    height: ScreenUtil().setWidth(150),
                    margin: EdgeInsets.symmetric(horizontal:20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffDBE1EB)
                    ),
                    child:InkWell(
                      onTap:(){
                        _pageController.nextPage(
                          duration: Duration(microseconds:500), 
                          curve: Curves.easeInCirc
                        );
                      },
                      child:Text('下一步',style: TextStyle(fontSize:20,color:Color(0xff313131)),)
                    )
                  ),
                ]
              );
            }
            if(index==1){
              return Container(
                width: 750,
                margin: EdgeInsets.symmetric(horizontal:20),
                child:Column(
                  children:<Widget>[
                    Container(
                      height: ScreenUtil().setHeight(165),
                      width: 750,
                      decoration:bottomBorderLine ,
                      alignment: Alignment.centerLeft,
                      child:Text('设置登录密码',style:TextStyle(fontSize:20,color:Color(0xff287DFD)))
                    ),
                    //登录密码
                    Container(
                      decoration: bottomBorder,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border:InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: "请设置登录密码",
                          prefixIcon: Image.asset('image/icon_password.png',),
                          suffixIcon: InkWell(
                            onTap: (){
                              changePassType();
                            },
                            child:Image.asset(
                              cur ? 'image/eye_on.png':'image/eye_off.png',scale: 0.65,
                            ),
                          )
                        ),
                        obscureText: obscureText,
                      ),
                    ),
                    //确认登录密码
                    Container(
                      decoration: bottomBorder,
                      child: TextField(
                        controller: _repasswordController,
                        decoration: InputDecoration(
                          border:InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: "请确认登录密码",
                          prefixIcon: Image.asset('image/icon_password.png',),
                          suffixIcon: InkWell(
                            onTap: (){
                              changePassType();
                            },
                            child:Image.asset(
                              cur ? 'image/eye_on.png':'image/eye_off.png',scale: 0.65,
                            ),
                          )
                        ),
                        obscureText: obscureText,
                      ),
                    ),
                    //资金密码
                    Container(
                      decoration: bottomBorder,
                      child: TextField(
                        controller: _capitalpasswordController,
                        decoration: InputDecoration(
                          border:InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: "请输入资金密码",
                          prefixIcon: Image.asset('image/icon_password.png',),
                          suffixIcon: InkWell(
                            onTap: (){
                              changePassType();
                            },
                            child:Image.asset(
                              cur ? 'image/eye_on.png':'image/eye_off.png',scale: 0.65,
                            ),
                          )
                        ),
                        obscureText: obscureText,
                      ),
                    ),
                    //确认资金密码
                    Container(
                      decoration: bottomBorder,
                      child: TextField(
                        controller: _recapitalpasswordController,
                        decoration: InputDecoration(
                          border:InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: "请确认资金密码",
                          prefixIcon: Image.asset('image/icon_password.png',),
                          suffixIcon: InkWell(
                            onTap: (){
                              changePassType();
                            },
                            child:Image.asset(
                              cur ? 'image/eye_on.png':'image/eye_off.png',scale: 0.65,
                            ),
                          )
                        ),
                        obscureText: obscureText,
                      ),
                    ),
                    Container(
                      width: 750,
                      height: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.symmetric(vertical:50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xffDBE1EB)
                      ),
                      child:InkWell(
                        onTap:(){
                          _pageController.nextPage(
                            duration: Duration(microseconds:500), 
                            curve: Curves.easeIn
                          );
                        },
                        child:Text('下一步',style: TextStyle(fontSize:20,color:Color(0xff313131)),)
                      )
                    ),
                  ]
                )
              );
            }
             if(index==2){
              return Container(
                width: 750,
                margin: EdgeInsets.symmetric(horizontal:20),
                child:Column(
                  children:<Widget>[
                    Container(
                      height: ScreenUtil().setHeight(165),
                      width: 750,
                      decoration:bottomBorderLine ,
                      alignment: Alignment.centerLeft,
                      child:Text('验证码',style:TextStyle(fontSize:20,color:Color(0xff287DFD)))
                    ),
                    //验证码
                    Container(
                      decoration: bottomBorder,
                      child:TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          border:InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 17.0),
                          hintText: codeType,
                          prefixIcon: Image.asset('image/icon_safe.png',),
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical:5),
                            child:Container(
                              width:100,
                              height: 0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:Color(0xffF3F8FF),
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child:InkWell(
                                onTap:(){
                                  if (countdownTime == 0) {
                                    startCountdown();
                                    _getCode();
                                  }
                                },
                                child: Text(
                                  countdownTime>0?"还剩${countdownTime}s":"验证码",
                                  style: TextStyle(color:countdownTime>0 ? Colors.black : Color(0xff287DFD) ,fontSize: 17),
                                ),
                              )
                            )
                          )
                        ),
                      ),
                    ),
                    //邀请码
                    Container(
                      decoration: bottomBorder,
                      child: TextField(
                        controller: _inviteController,
                        decoration: InputDecoration(
                          border:InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: "请输入邀请码（选填）",
                          prefixIcon: Image.asset('image/icon_yaoqingma.png',),
                        ),
                        obscureText: obscureText,
                      ),
                    ),
                    Container(
                      width: 750,
                      height: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.symmetric(vertical:50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF5D9EFF), Color(0xFF287DFD)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child:InkWell(
                        onTap:(){
                          _register();
                        },
                        child:Text('立即注册',style: TextStyle(fontSize:20,color:Colors.white,))
                      )
                    ),
                  ]
                )
              );
            }
          },childCount:3)
        ),
      ) ,
    );
  }
  //手机表单
  Widget phoneLogin(){
    return Container(
      decoration: bottomBorderLine,
      padding: EdgeInsets.symmetric(vertical:20),
      child: TextField(
        controller: _phoneController,
        decoration: InputDecoration(
          hintText: "请输入手机号",
          border:InputBorder.none,
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
      decoration: bottomBorderLine,
      padding: EdgeInsets.only(top:10),
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