import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventChannelPage extends StatefulWidget {
  @override
  _EventChannelPageState createState() => _EventChannelPageState();
}

class _EventChannelPageState extends State<EventChannelPage> {
  static const _stream = const EventChannel('com.meetup.no_plugins/eventChannelDemo');
  String _orientation = "Portrait";
  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    subscription = _stream.receiveBroadcastStream().listen((orientation){
      setState(() {
        _orientation = orientation;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Channel'),
      ),
      body: Center(child: Text(_orientation, style: Theme.of(context).textTheme.display2,)),
    );
  }
}
