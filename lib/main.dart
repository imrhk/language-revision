import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

import 'data.dart';

TextStyle? textStyle;
double space = 5;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, scaffoldBackgroundColor: Colors.black),
      themeMode: ThemeMode.dark,
      home: const SelectionPage(),
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      textStyle = const TextStyle(fontSize: 24);
      return WatchShape(
        builder: ((context, shape, child) {
          return child!;
        }),
        child: materialApp,
      );
    } else {
      textStyle = const TextStyle(fontSize: 40);
      space = 20;
      return materialApp;
    }
  }
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(
                '🇬🇧 → 🇫🇷',
                style: textStyle,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ExcercisePage(data: englishToFrench)));
              },
            ),
            SizedBox(
              height: space,
            ),
            ElevatedButton(
              child: Text(
                '🇫🇷 → 🇬🇧',
                style: textStyle,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ExcercisePage(data: frenchToEnglish)));
              },
            ),
            SizedBox(
              height: space,
            ),
            ElevatedButton(
              child: Text(
                '🇬🇧 ↔ 🇫🇷',
                style: textStyle,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ExcercisePage(data: () {
                          final map = <String, String>{
                            ...frenchToEnglish,
                            ...englishToFrench
                          };
                          final list = map.entries.toList()..shuffle();
                          return Map.fromEntries(list);
                        }())));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExcercisePage extends StatelessWidget {
  final Map<String, String> data;
  const ExcercisePage({Key? key, this.data = const {}}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final axis = MediaQuery.of(context).size.aspectRatio > 1
        ? Axis.horizontal
        : Axis.vertical;
    return Scaffold(
      appBar: defaultTargetPlatform != TargetPlatform.android ? AppBar() : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StatefulBuilder(builder: (context, setState) {
            return CarouselSlider.builder(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                scrollDirection: axis,
                enableInfiniteScroll: false,
                viewportFraction: 0.9,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              itemBuilder: (context, index, realIndex) {
                final item = data.entries.toList()[index];
                return FlipCard(
                  key: ValueKey(item),
                  direction: FlipDirection.VERTICAL,
                  front: Card(
                    color: const Color.fromARGB(255, 22, 20, 20),
                    child: Center(
                      child: Text(
                        item.key,
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  back: Card(
                    color: [
                      Colors.red[700],
                      Colors.green[700],
                      Colors.purple[700],
                      Colors.amber[700],
                    ][index % 4],
                    child: Center(
                        child: Text(
                      item.value,
                      style: textStyle?.copyWith(
                          color: index % 4 == 3 ? Colors.black87 : null),
                      textAlign: TextAlign.center,
                    )),
                  ),
                );
              },
              itemCount: data.length,
            );
          }),
        ),
      ),
    );
  }
}
