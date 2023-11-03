import 'dart:async';
import 'package:animated/animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_catalog/Screens/CatalogScreen/catalog_screen.dart';
import 'package:my_catalog/Styles/styles.dart';

class SplashScreen extends StatefulWidget {


  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool scaled = false;
  bool isDouble = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isDouble = true;
    });
    Timer(const Duration(seconds: 1), () {
      setState(() {
        scaled = true;
      });
      _navigateHome();
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 3500),() async {
      if(isDouble == true) {
        setState(() {
          isDouble = false;
        });

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const CatalogScreen(),
            transitionDuration: const Duration(milliseconds: 500), //Duration.zero,
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),

          ),
        );

        // Navigator.pushAndRemoveUntil(context,
        //     CupertinoPageRoute(builder: (BuildContext context) =>  SecondPageRoute()), ( Route<dynamic> route) => false);
      }
    });
  }

  Widget _navigateHomeAnimation()  {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Color(0xFFEE866A), Color(0xFFFA5C45)]
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Animated(
            value: scaled ? 1 : .0,
            curve: Curves.easeInExpo,
            duration:  Duration(milliseconds: defaultTargetPlatform == TargetPlatform.iOS ? 500 : 1000),
            builder: (context, child, animation) => Opacity(
              opacity: animation.value,
              child: child,
            ),
            child: Text(translate('default.online'),style: ThemeText.textFontSize(color: Styles.white,fontSize: 16), textAlign: TextAlign.left)
          ),
          Animated(
            value: scaled ? 2.0 : 0,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
            builder: (context, child, animation) => Transform.scale(
              scale: animation.value,
              child: child,
            ),
              child: Text(translate('default.demo_catalog'),style: ThemeText.textFontSize(color: Styles.white,fontSize: 16), textAlign: TextAlign.left)
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigateHome();
    return _navigateHomeAnimation();
  }
}

//плавный переход
class SecondPageRoute extends CupertinoPageRoute {
  SecondPageRoute() : super(builder: (BuildContext context) => const CatalogScreen());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: const CatalogScreen());
  }

}