import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:is_wear/is_wear.dart';
import 'package:wear/wear.dart';

import 'data.dart';

TextStyle? textStyle;
double space = 5;

bool shuffle = true;

late bool isWear;

WearShape? shape;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    isWear = (await IsWear().check()) ?? false;
  } catch (_) {
    isWear = false;
  }

  runApp(const App());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      themeMode: ThemeMode.dark,
      home: const SelectionPage(),
    );

    if (isWear) {
      textStyle = const TextStyle(fontSize: 18);
      return WatchShape(
        builder: ((context, s, child) {
          shape = s;
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

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: isWear
            ? null
            : AppBar(
                title: const Text('Language Revision'),
              ),
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
                            final list = map.entries.toList();
                            if (shuffle) {
                              list.shuffle();
                            }
                            return Map.fromEntries(list);
                          }())));
                },
              ),
              SizedBox(
                height: space,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: shuffle,
                    onChanged: (value) {
                      shuffle = value!;
                      setState(() {});
                    },
                  ),
                  Text(
                    'Shuffle',
                    style: textStyle,
                  ),
                ],
              ),
            ],
          ),
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
    final pageView = PageView.builder(
      scrollDirection: Axis.vertical,
      padEnds: false,
      itemBuilder: (context, index) {
        final item = data.entries.toList()[index];
        return ItemWidget(item: item, index: index, length: data.length);
      },
      itemCount: data.length,
    );

    final scaffold = Scaffold(
      appBar: isWear
          ? null
          : AppBar(
              title: const Text('Language Revision'),
            ),
      body: Center(
        child: Padding(
          padding: isWear
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
          child: pageView,
        ),
      ),
    );

    if (isWear) {
      return scaffold;
    } else {
      return SafeArea(child: scaffold);
    }
  }
}

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    Key? key,
    required this.item,
    required this.index,
    required this.length,
  }) : super(key: key);

  final MapEntry<String, String> item;
  final int index;
  final int length;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> with TickerProviderStateMixin {
  bool flipped = false;

  Animation<Color?>? animation;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  void animate() {
    if (!flipped) {
      controller?.reverse();
      return;
    }

    final endColor = [
      Colors.red[700],
      Colors.green[700],
      Colors.purple[700],
      Colors.amber[700],
    ][widget.index % 4]!;

    controller?.stop();

    final localAnimation = animation =
        ColorTween(begin: const Color.fromARGB(255, 22, 20, 20), end: endColor)
            .animate(controller!);

    localAnimation.addListener(() {
      if (localAnimation != animation) {
        return;
      } else {
        setState(() {});
      }
    });

    controller?.forward();
  }

  Color get cardColor {
    if (flipped) {
      return [
        Colors.amber[700],
        Colors.green[700],
        Colors.purple[700],
        Colors.red[700],
      ][widget.index % 4]!;
    } else {
      return const Color.fromARGB(255, 22, 20, 20);
    }
  }

  TextStyle? get contentTextStyle {
    if (flipped) {
      return textStyle?.copyWith(
          color: widget.index % 4 == 3 ? Colors.black87 : null);
    } else {
      return textStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey(widget.item),
      onTap: () {
        setState(() {
          flipped = !flipped;
          animate();
        });
      },
      child: Card(
          shape: shape == WearShape.round
              ? const CircleBorder(
                  side: BorderSide(),
                )
              : null,
          color: animation?.value ?? const Color.fromARGB(255, 22, 20, 20),
          child: Padding(
            padding: isWear
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8,
                  ),
            child: Stack(
              children: [
                Center(
                  child: () {
                    final column = Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.key,
                          style: contentTextStyle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: space * 2,
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: flipped ? 1 : 0,
                          child: Text(
                            widget.item.value,
                            style: contentTextStyle,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    );
                    if (shape == WearShape.round) {
                      // return ClipPath(
                      //   clipper: CircularClipper(),
                      //   clipBehavior: Clip.hardEdge,
                      //   child: column,
                      // );
                      Size size = MediaQuery.of(context).size;
                      //45-degree
                      double x = (size.width / 2 * sin(0.785398)).abs();
                      return SizedBox.square(
                        dimension: x * 2,
                        child: column,
                      );
                    } else {
                      return column;
                    }
                  }(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Chip(
                    label: Text('${widget.index + 1}/${widget.length}'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class CircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final Path path = Path()
      ..addOval(Rect.fromLTWH(0, 0, width, height))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
