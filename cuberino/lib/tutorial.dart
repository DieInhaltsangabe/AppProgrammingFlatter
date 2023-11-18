import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key, required this.parentId});
  final int parentId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
            child: Text('Heading'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'assets/starter.jpeg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                  child: Text(
                      'Wir starten mit dem Lösen der weißen Kanten. Du kannst natürlich auch mit jeder anderen Farbe beginnen, doch in diesem Tutorial nehmen wir die weiße Seite als Beispiel. Wir wissen ja bereits, dass die mittleren Steine immer am gleichen Platz bleiben. Deshalb müssen wir darauf aufpassen, dass auch die zweite Farbe der Kanten mit den mittleren Steine der mittleren Seite übereinstimmt. Dieser Schritt ist intuitiv und relativ einfach, da es noch nicht so viele gelöste Steine gibt, auf die man achten muss. In vielen Fällen muss man die Kanten nur in ihren gelösten Zustand drehen. Hier sind noch ein paar Beispiele, die etwas spezieller sind.'))),
        ],
      ),
    );
  }
}
