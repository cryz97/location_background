import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Location Notifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Background Location Notifier'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location _locationService = new Location();

  var loc;
  @override
  void initState() {
    super.initState();
  }

  static void backgroundCallback(List<LocationData> locations) async {
    print('lat : ${locations[0].latitude}');
    print('lng : ${locations[0].longitude}');
    var body = {
      "lat": '${locations[0].latitude}',
      "lng": '${locations[0].longitude}'
    };
    var header = {
      //'Content-Type': 'application/json',asjaskdlassasksakjafjabjkashdjaksdskjsaasjbasjksadjsakbnujhifoahnkalsdktischfiowhsa;dhioqwdhslaskfhiowh0iawjksahasjkashajkaj;akajahfasjkdhasjkdas;dsahjkahjak

      'Accept': 'application/json'
    };
    http
        .post('http://8f979495.ngrok.io/api/location',
            body: body, headers: header)
        .then((res) {
      print(res.statusCode);
    });
  }

  void _registerListener() async {
    bool _permission = await _locationService.requestPermission();
    print("Permission: $_permission");
    if (_permission) {
      _locationService.changeSettings(interval: 10000);
      bool statusBackgroundLocation =
          await _locationService.registerBackgroundLocation(backgroundCallback);
      print("statusBackgroundLocation: $statusBackgroundLocation");
    } else {
      print("Permission denied");
    }
  }

  void _removeListener() async {
    await _locationService.removeBackgroundLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _registerListener();
              },
              child: const Text('Register background service'),
            ),
            RaisedButton(
              onPressed: () {
                _removeListener();
              },
              child: const Text('Remove background service'),
            ),
          ],
        ),
      )),
    );
  }
}
