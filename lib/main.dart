import 'package:Kkubex/application.dart';
import 'package:Kkubex/privoder/indexNotifire.dart';
import 'package:Kkubex/routes/navigate_service.dart';
import 'package:Kkubex/routes/routes.dart';
import 'package:Kkubex/view/login_reg_forget/login_page.dart';
import 'package:Kkubex/view/splash/splash.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Router router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  Application.setupLocator();
  PageController pageController;
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context)=>GuidPage(pageController))
      ],
      child:MyApp()),
   );
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kkubex',
      navigatorKey: Application.getTt<NavigateService>().key,
      theme: ThemeData(
        primaryColor: Color(0xff287DFD),
        splashColor: Colors.transparent,
        tooltipTheme: TooltipThemeData(verticalOffset: -100000)
      ),
      home: SplashPage(),
      onGenerateRoute: Application.router.generator,
    );
  }
}