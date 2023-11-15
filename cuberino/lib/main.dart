import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuberino',
      
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Color background = Color(0xFF1C2757);
  Color secondBackground = Color(0xFF323F68);
  String timerInstruction = "Press and hold to start the timer.";

  int seconds = 0, minutes = 0, milliseconds = 0;
  String digitSeconds = "00", digitMinutes = "00", digitMilliseconds = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  String currentScramble = "";


  // stop timer func
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  // reset
  void reset() {
    timer!.cancel();
    setState(() {
      milliseconds = 0;
      seconds = 0;
      minutes = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitMilliseconds = "00";

      started = false;
    });
  }

  void start() {
    started = true;
    digitSeconds = "00";
    digitMinutes = "00";
    digitMilliseconds = "00";
    seconds = 0;
    minutes = 0;
    milliseconds = 0;
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      int localMilliseconds = milliseconds + 1;
      int localSeconds = seconds;
      int localMinutes = minutes;

      if(localMilliseconds > 99) {
        if (localSeconds > 59) {
          localMinutes++;
          localSeconds = 0;
        }
        else{
          localSeconds++;
          localMilliseconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        milliseconds = localMilliseconds;
        digitSeconds = (seconds >= 10) ? "$seconds":"0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes":"0$minutes";
        digitMilliseconds = (milliseconds >= 10) ? "$milliseconds":"0$milliseconds";
      });

    });
  }

  void getScramble(){
    const moves = ["L", "R", "F", "D", "B", "U"];
    Map<String, String> inverts = {
      "L" : "L'",
      "R" : "R'",
      "F" : "F'",
      "D" : "D'",
      "B" : "B'",
      "U" : "U'",
      "2L" : "2L",
      "2R" : "2R",
      "2B" : "2B",
      "2D" : "2D",
      "2F" : "2F",
      "2U" : "2U",
      "R'" : "R",
      "L'" : "L",
      "U'" : "U",
      "B'" : "B",
      "F'" : "F",
      "D'" : "D",
    };
    var random = Random();
    var scramble = [];
    var len = scramble.length;
    // Single, Double, Revert
    while (scramble.length < 20) {
      var move = random.nextInt(moves.length);
      var type = random.nextInt(3);
      switch(type){
        case 0: //single thingie
          if (scramble.isEmpty){
            scramble.add(moves[move]);
          }
          else if ( scramble[scramble.length-1] == moves[move]){
            scramble[scramble.length-1] = "2${moves[move]}";
          }
          else if ( scramble[scramble.length-1] == inverts[moves[move]]){
            break;
          }
          else if(scramble[scramble.length-1] == "2${moves[move]}"){
            break;
          }
          else {
            scramble.add(moves[move]);
          }
          break;
        case 1: //double move
          if (scramble.isEmpty){
            scramble.add("2${moves[move]}");
          }
          else if ((scramble[scramble.length-1] == ("2${moves[move]}"))|| (scramble[scramble.length-1] == inverts["2${moves[move]}"])){
            break;
          }
          else if(scramble[scramble.length-1] == moves[move] || scramble[scramble.length-1] == inverts[move]){
            break;
          }
          else {
            scramble.add("2${moves[move]}");
          }
          break;
        case 2: //invers
          if (scramble.isEmpty){
            scramble.add("${moves[move]}'");
          }
          else if(scramble[scramble.length-1] == "${moves[move]}'"){
            scramble[scramble.length-1] = "2${moves[move]}";
          }
          else if(scramble[scramble.length-1] == moves[move] || scramble[scramble.length-1] == "2${moves[move]}"){
            break;
          }
          else {
            scramble.add("${moves[move]}'");
          }
          break;
        default:break;
      }
    }
    setState(() {
      currentScramble = scramble.join("  ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  visible: !started,
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.zero,
                    decoration: BoxDecoration(
                      color: secondBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 11, left: 15),
                        child: Text(
                          currentScramble,
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
                Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  visible: !started,
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RawMaterialButton(
                              onPressed: () {
                                getScramble();
                              },
                              shape: StadiumBorder(side: BorderSide(color: Colors.blue),
                              ),
                              child: Text("Generate Scramble", style: TextStyle(color: Colors.white),)
                          ),
                        ),
                      ]
                  ),
                ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Text(
                    "$digitMinutes:$digitSeconds:$digitMilliseconds",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 82.0,
                        fontWeight: FontWeight.bold,
                    ),
                ),
              ),
              Text(
                timerInstruction,
                  style: TextStyle(
                    color: Colors.teal.shade100,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
              ),
              Listener(
                onPointerDown: (event) {
                  if(background == Color(0xFF1C2757)){
                    Timer.periodic(Duration(milliseconds: 1500), (timer) {
                      setState(() {
                        if(!started) {
                          background = Colors.green;
                          secondBackground = Colors.lightGreen;
                          timerInstruction = "Let go to start the timer. \nPress again to stop the timer.";

                        }
                        timer.cancel();
                      });

                    });
                  }
                  else{
                    stop();
                    background = Color(0xFF1C2757);
                    secondBackground = Color(0xFF323F68);
                    timerInstruction = "Press and hold to start the timer.";
                  }
                },
                onPointerUp: (event) {
                  if(background ==  Colors.green){
                    start();

                  }
                },
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: secondBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ]
          )
        )
      )
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
