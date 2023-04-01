import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[]; // like 누른 word pair 저장하기 위한 empty list

  void toggleFavorite() { // like 버튼 누르고/안 누르고 toggling
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon; // icon 불러오기 (왜 여기다가 하는 걸까? appstate는 아니고 build할 때 불러오기만 하면 돼서?)
    if (appState.favorites.contains(pair)) { // like 버튼 누르고/안 누르고 toggling
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center( // center로 감싸서 column을 vertical하게 중앙 정렬 시켜줌
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // child를 column 내에서 horizontal하게 중앙 정렬 
          children: [
            // Text('A random AWESOME idea:'),
            // Text(appState.current.asLowerCase),
            BigCard(pair: pair),
            SizedBox(height: 10), // 단어랑 next 버튼 사이에 간격 띄워주기..? 굳이 padding 안 쓰고 box를 넣어버리는군
            Row( // 가로로 버튼 2개 넣기 위해 생성
            mainAxisSize: MainAxisSize.min, // child로 가지고 있는 것들 사이즈 그대로
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                  appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like')
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('button pressed!');
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
      
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget { // assigned name "BigCard" to new class
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // First, the code requests the app's current theme
    final style = theme.textTheme.displayMedium!.copyWith( // '!' operator to assure Dart i know what i'm doing (it's not null!)
      color: theme.colorScheme.onPrimary, // primary에 썼을 때 잘 보이는 색깔
    );

    return Card(
      color: theme.colorScheme.primary, // Then, the code defines the card's color to be the same as the theme's colorScheme property.
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // child: Text(pair.asLowerCase),
        // child: Text(pair.asLowerCase, style: style),
        // child: Text("${pair.first} ${pair.second}", style: style),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // 이렇게 하면 시스템 상에서는 띄어쓰기를 인식하는데?(e.g. 보이스 reader) UI는 띄어쓰기 X인 상태로 나옴
        )
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
