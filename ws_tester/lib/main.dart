import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'get_call_ws.dart';
import 'items.dart';

void main() => runApp(new MaterialApp(
      title: "WS Tester",
      home: WebServiceTesterUI(),
    ));

class WebServiceTesterUI extends StatefulWidget {
  @override
  _WebServiceTesterUIState createState() => _WebServiceTesterUIState();
}

class _WebServiceTesterUIState extends State<WebServiceTesterUI> {
  String _method = "GET";
  String _url;
  var _responseBody;
  List<items> _itemsList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WS Tester"),
        elevation: 20.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: _method,
                    items: <String>['GET', 'POST']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String selectedValue) {
                      setState(() {
                        _method = selectedValue;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "URL", border: InputBorder.none),
                    onSubmitted: (String url) {
                      _url = url;
                    },
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    get(_url).then((value) {
                      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
                      setState(() {
                        _responseBody = value;
                        _itemsList = _responseBody
                            .map<items>((json) => items.fromJson(json))
                            .toList();
                        _responseBody = encoder.convert(value);
                      });
                    });
                  },
                  textColor: Colors.white,
                  child: new Text(
                    "Send",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: _responseBody != null
                ? Container(
                    height: 200.0,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text('${_responseBody}'),
                    ),
                  )
                : Text("API Response Will be Displayed Here"),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _itemsList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: GridTile(
                    header: Text('${_itemsList[index].title}'),
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Image.network('${_itemsList[index].imageUrl}'),
                    ),
                    footer: Row(
                      children: <Widget>[
                        Icon(Icons.attach_money),
                        Text('${_itemsList[index].price}')
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget loadingView() => Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black26,
        ),
      );
}
