
import 'package:flutter/material.dart';
import 'package:interactive_viewer_wrapper/interactive_viewer_wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Widget> _mediaItems = [
    Image.network(
      'https://cdn.glitch.com/c5e40497-6ba3-43ed-9946-c5b1b8416f91%2Fgoods_419693_sub7.jpg?v=1571806411819',
      fit: BoxFit.cover,
    ),
    Image.network(
      'https://cdn.glitch.com/c5e40497-6ba3-43ed-9946-c5b1b8416f91%2Fgoods_419693_sub2.jpg?v=1571806412681',
      fit: BoxFit.cover,
    ),
    Image.network(
      'https://cdn.glitch.com/c5e40497-6ba3-43ed-9946-c5b1b8416f91%2Fgoods_419693_sub11.jpg?v=1571806412345',
      fit: BoxFit.cover,
    ),
    Image.network(
      'https://cdn.glitch.me/c5e40497-6ba3-43ed-9946-c5b1b8416f91%2Fgoods_02_419693.jpg',
      fit: BoxFit.cover,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Interactive Viewer Wrapper Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        children: _mediaItems,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Widget> children;

  const MyHomePage({super.key, required this.children});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int get itemCount => widget.children.length;

  bool _pagingEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: const Key("example_page_view"),
      padEnds: false,
      pageSnapping: true,
      scrollDirection: Axis.vertical,
      physics: _pagingEnabled
          ? const PageScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final childWidget = widget.children[index % widget.children.length];

        return InteractiveViewerWrapper(
          onScaleChanged: (scale) {
            setState(() {
              // Disable paging when child is zoomed-in
              _pagingEnabled = scale <= 1.0;
            });
          },
          child: childWidget,
        );
      },
    );
  }
}
