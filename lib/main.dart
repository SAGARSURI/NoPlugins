import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'method_channel_page.dart';
import 'event_channel_page.dart';

main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);
    return MaterialApp(
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Channels'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: (){
              final page = MethodChannelPage();
              navigate(context, page);
            }, child: Text('Method Channel'),),

            RaisedButton(onPressed: (){
              final page = EventChannelPage();
              navigate(context, page);
            }, child: Text('Event Channel'),)
          ],
        ),
      ),
    );
  }

  void navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => page,
        transitionsBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween<Offset>(
                end: Offset(0, 0), begin: Offset(1, 0))
                .animate(anim1),
            child: page,
          );
        },
      ),
    );
  }
}
