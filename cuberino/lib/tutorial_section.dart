import 'package:flutter/material.dart';
import 'bottom_app_bar.dart';

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
      bottomNavigationBar: BottomMenu(true, true, false),
    );
  }
}