import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRIPTRACK',
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String buttonText = 'Motor off';
  Color buttonColor = Colors.red;
  int ledValue = 0;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // late AndroidNotificationChannel channel;




  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('soil_status')
        .orderBy('datetime', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot latestDocument = snapshot.docs.first;
        int newLedValue = latestDocument['led_status'] ?? 0;
        if (ledValue != newLedValue){
        ledValue = newLedValue;
        updateButtonWithDelay();
        }
        setState(() {});
      }
  } );}

  void updateButtonWithDelay() async {
  await Future.delayed(Duration(seconds: 10));
  updateButton();
}

  void updateButton() {
buttonColor = ledValue == 1 ? Colors.green : Colors.red;
buttonText = ledValue == 1 ? 'Motor on' : 'Motor off';
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRIPTRACK', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('soil_status') .orderBy('datetime', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data.'),
            );
          }


          if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      print(snapshot.data);


      List<DocumentSnapshot> documents = snapshot.data!.docs;


      // DocumentSnapshot latestDocument = snapshot.data!.docs.first;
      // int ledValue = latestDocument['LED'] ?? 0;
      // buttonColor = ledValue == 1 ? Colors.green : Colors.red;
      // buttonText = ledValue == 1 ? 'Motor on' : 'Motor off';
     
      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot document = documents[index];
          String dateTimeString = document['datetime'] ?? 'N/A';
          // String motorStatus = document['motor_status'] ?? 'N/A';
          // setState(() {
          //       motorStatus = document['motor_status'] ?? 'N/A';
          //     });
          // String dateString = document['date'] ?? 'N/A';
          // DateTime dateTime = DateTime.parse('$dateString $timeString');


          // String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
          // String formattedTime = DateFormat('HH:mm:ss').format(dateTime);


          return ListTile(
            title: Text('Recommendation: ${document['motor_status'] ?? 'N/A'}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Humidity: ${document['humidity'] ?? 'N/A'}'),
                Text('Temperature: ${document['temperature'] ?? 'N/A'}'),
                Text('Moisture Content: ${document['capacitive'] ?? 'N/A'}'),
                Text('Soil Condition: ${document['soil_condition'] ?? 'N/A'}'),
                // Text('pH Value: ${document['ph'] ?? 'N/A'}'),
                Text('DateTime: $dateTimeString'),
                // Text('Time: $timeString'),
              ],
            ),
          );
        }
      );
  }),
  floatingActionButton: FloatingActionButton.extended(
        label: Text(
          buttonText,
          style: TextStyle(color:Colors.black),
        ),
        onPressed: () {
      setState(() {
        updateButton();
  });
},
        backgroundColor: buttonColor,
      ),
    );
  }}
