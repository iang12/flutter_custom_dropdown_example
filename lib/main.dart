import 'package:flutter/material.dart';

import 'custom_dropdown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Dropdown Demo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomDropdown(
                initialSelectedValue: 'Placeholder',
                onChangeValue: (value) => debugPrint('apertou: $value'),
                itemHeight: 40,
                dropHeight: 150,
                items: [
                  'Field 1',
                  'Field 2',
                  'Field 3',
                  'Field 4',
                  'Field 5',
                ],
              ),
              SizedBox(
                height: 20
              ),
              CustomDropdown(
                isMultiSelect: true,
                initialSelectedValue: 'Placeholder',
                onChangeValue: (value) => debugPrint('apertou: $value'),
                itemHeight: 40,
                dropHeight: 150,
                items: [
                  'Field 1',
                  'Field 2',
                  'Field 3',
                  'Field 4',
                  'Field 5',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
