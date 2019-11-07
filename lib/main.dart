import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quakes;
List _features; // features object list
void main() async{

  _quakes = await getQuakes();
  //print(_quakes['features']);
  _features = _quakes['features'];
  runApp(new MaterialApp(
    title: 'Quakes',
    home: Quakes(),
  ));
}

class Quakes extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),

      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context,int position){
              //Creating the Rows for Our ListView
              if(position.isOdd) return new Divider();
              final index = position ~/ 2; // We are dividing position by 2 and returning an Integer Result!

              //var format = new DateFormat("yMd");
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time'] * 1000,
              isUtc: true));

              return new ListTile(
                title: new Text("At: $date",
                style: new TextStyle(fontSize: 14.5,
                color: Colors.orange,
                fontWeight: FontWeight.w500),),
                
                subtitle: new Text("${_features[index]['properties']['title']}",
                style: new TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic
                ),),

                leading: new CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: new Text("${_features[index]['properties']['mag']}",
                  style: new TextStyle(fontSize: 14.5,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),),
                ),

                onTap: () {_showOnTapMessage(context,"${_features[index]['properties']['title']}");},

              );

            }),
      ),

    );
  }

  void _showOnTapMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Quakes'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(onPressed: (){Navigator.pop(context);},
            child: new Text("Ok"))
      ],
    );
    
    showDialog(context: context,builder: (context){
      return alert;
    });
  }
}

Future<Map> getQuakes() async{
  String apiURL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson';
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}