import 'package:Kkubex/privoder/indexNotifire.dart';
import 'package:Kkubex/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
 PageController _pageController;

  List imgs = [
    'image/01.png',
    'image/02.png',
    'image/03.png',
  ];

  @override
  void initState() { 
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() { 
    _pageController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body:ChangeNotifierProvider(
        create: (context) => GuidPage(_pageController),
        child:PageView(
          controller: _pageController,
          // onPageChanged: (int index){
          //   Provider.of<GuidPage>(context,listen: false).index = index;
          // },
          children: <Widget>[
            Consumer<GuidPage>(
              builder: (context,notifier,child){
                return Transform.scale(
                  origin: Offset(100, 400),
                  scale: math.max(0, 1 - notifier.page),
                  child: Opacity(
                    opacity: math.max(0, math.max(0, 1 - notifier.page)),
                    child: Image.asset(imgs[0],fit: BoxFit.cover,),
                  ),
                );
              }
            ),
            Consumer<GuidPage>(
              builder: (context,notifier,child){
                return Transform.rotate(
                  origin: Offset(0, 0),
                  angle: math.max(0, (math.pi/2) * 4 * notifier.page),
                  child: Image.asset(imgs[1],fit: BoxFit.cover,),
                );
              }
            ),
            Stack(
              fit: StackFit.expand,
              children:<Widget>[
                Image.asset(imgs[2],fit: BoxFit.cover,),
                Positioned(
                  bottom: 70,
                  left: 120,
                  child: InkWell(
                    onTap: (){
                      NavigatorUtil.goLoginPage(context);
                    },
                    child:Container(
                      width: 170,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border:Border.all(width:1,color:Color(0xff287DFD)),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child:Text('立即体验',style: TextStyle(color:Color(0xff287DFD),fontSize: 20),) ,
                    )
                  ),
                )
              ]
            )
          ],
        )
      )
    );
  }
}