import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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

/* TUTORIAL 1-6 */
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon; // icon 불러오기 (왜 여기다가 하는 걸까? appstate는 아니고 build할 때 불러오기만 하면 돼서?)
//     if (appState.favorites.contains(pair)) { // like 버튼 누르고/안 누르고 toggling
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Scaffold(
//       body: Center( // center로 감싸서 column을 vertical하게 중앙 정렬 시켜줌
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // child를 column 내에서 horizontal하게 중앙 정렬 
//           children: [
//             // Text('A random AWESOME idea:'),
//             // Text(appState.current.asLowerCase),
//             BigCard(pair: pair),
//             SizedBox(height: 10), // 단어랑 next 버튼 사이에 간격 띄워주기..? 굳이 padding 안 쓰고 box를 넣어버리는군
//             Row( // 가로로 버튼 2개 넣기 위해 생성
//             mainAxisSize: MainAxisSize.min, // child로 가지고 있는 것들 사이즈 그대로
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                   appState.toggleFavorite();
//                   },
//                   icon: Icon(icon),
//                   label: Text('Like')
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     print('button pressed!');
//                     appState.getNext();
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
      
//           ],
//         ),
//       ),
//     );
//   }
// }

/* From Tutorial 7 */
class MyHomePage extends StatefulWidget {
  // 여기서는 navigationRail의 selectedIndex를 widget 내부의 정보를 변경하고 hold하고 싶어서..? state가 필요하다고 함
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // selectedIndex를 일단 0으로 init
  
  @override
  Widget build(BuildContext context) {
    Widget page; // 새로운 varable (얜 왜 또 여기서 정의??) 밖에서 하면 안 되나?
    switch (selectedIndex) { // 아무튼 selectedIndex에 따라 switch 됨
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        // page = Placeholder(); // FavoritesPage가 들어갈 예정
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder( // app의 window 사이즈 변경하면 그에 따라 builder callback이 called
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea( // hardware의 notch나 status bar에 가려지지 않도록 도와줌
                child: NavigationRail(
                  // extended: false, // 이걸 true로 바꾸면 navigation바가 가로로 길어짐 (왜지??)
                  // // https://api.flutter.dev/flutter/material/NavigationRail/extended.html
                  // // https://velog.io/@tmdgks2222/Flutter-State
                  extended: constraints.maxWidth >= 600, // 화면 가로가 600px 넘으면 navigation text도 보여줌
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  // selectedIndex: 0, // 지금은 0(home)으로 hard coded (그냥 초기값인가?)
                  selectedIndex: selectedIndex, // hard coded된 데이터가 아니라 variable 정보 가져오기
                  onDestinationSelected: (value) {
                    // print('selected: $value');
                    setState(() {
                      selectedIndex = value; // destination 누를 때마다 selectedIndex를 바꿔주기
                    });
                  },
                ),
              ),
              Expanded( // 안에 GeneratorPage를 넣었군
              // Expanded는 SafeArea가 가져가고 남은 부분을 다 가져오는 애
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  // child: GeneratorPage(),
                  child: page, // 이제 navigation에서 뭘 누르느냐에 따라 다름
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView( // scroll 가능한 list view
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
          '${appState.favorites.length} favorites:'),
          ),
          for (var pair in appState.favorites)
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(pair.asLowerCase),
            )

      ],
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