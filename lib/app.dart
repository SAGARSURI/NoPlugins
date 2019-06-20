import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('com.meetup.no_plugins/demo');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("No Plugins"),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[osVersionButton()],
          ),
        ),
      ),
    );
  }

  Builder osVersionButton() {
    return Builder(
      builder: (context) => RaisedButton(
            onPressed: () {
              _getOSVersion().then((value) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value),
                    duration: Duration(seconds: 3),
                  ),
                );
              });
            },
            child: Text('OS Version'),
          ),
    );
  }

  Future<String> _getOSVersion() async {
    String version;
    try {
      version = await platform.invokeMethod('getOSVersion');
    } on PlatformException catch (e) {
      version = "Failed to get version name: ${e.message}";
    }
    return version;
  }
}
