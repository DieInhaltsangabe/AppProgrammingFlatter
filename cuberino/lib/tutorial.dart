import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: <Widget>[
          Card(child: Text('Test')),
          Card(child: Text('Test')),
          Card(child: Text('Test')),
          Card(child: Text('Test')),
        ],
      ),
    );
  }
}
