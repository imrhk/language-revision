import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:is_wear/is_wear.dart';
import 'package:language_learning/background_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wear/wear.dart';

import 'data.dart';

TextStyle? textStyle;
double space = 5;

bool shuffle = true;

late bool isWear;

WearShape? shape;

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

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
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF967bb6),
          brightness: Brightness.dark,
        ),
      ).copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
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
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  bool _isIntroShown = false;
  @override
  void initState() {
    super.initState();
    _isIntroShown = sharedPreferences.getBool('INTRO_SHOWN') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundWidget(),
          Scaffold(
            appBar: isWear
                ? null
                : AppBar(
                    title: const Text('Lingomelon'),
                  ),
            body: Center(
              child: Visibility(
                visible: _isIntroShown,
                replacement: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'App to practice language',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                        child: Text(
                          'Proceed',
                          style: textStyle?.copyWith(fontSize: 18),
                        ),
                        onPressed: () async {
                          await sharedPreferences.setBool('INTRO_SHOWN', true);
                          _isIntroShown = true;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntrinsicWidth(
                      child: FilledButton(
                        child: Text(
                          'English to French',
                          style: textStyle?.copyWith(fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  ExcercisePage(data: englishToFrench)));
                        },
                      ),
                    ),
                    SizedBox(
                      height: space,
                    ),
                    IntrinsicWidth(
                      child: FilledButton(
                        child: Text(
                          'French to English',
                          style: textStyle?.copyWith(fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  ExcercisePage(data: frenchToEnglish)));
                        },
                      ),
                    ),
                    SizedBox(
                      height: space,
                    ),
                    IntrinsicWidth(
                      child: FilledButton(
                        child: Text(
                          'English and French mix',
                          style: textStyle?.copyWith(fontSize: 18),
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
                          style: textStyle?.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExcercisePage extends StatelessWidget {
  final Map<String, String> data;
  const ExcercisePage({super.key, this.data = const {}});

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
    super.key,
    required this.item,
    required this.index,
    required this.length,
  });

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
        Colors.pink[700],
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
          color: animation?.value ?? const Color.fromARGB(255, 12, 12, 12),
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
