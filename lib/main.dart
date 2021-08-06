import 'package:flutter/material.dart';
import 'package:test_ar/debug_options_widget.dart';
import 'package:test_ar/local_object_widget.dart';
import 'package:test_ar/objects_on_planes_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rubik\'s Cube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Rubik\'s Cube'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
            Spacer(),
            Image.asset(
              "assets/images/icon.png",
              height: 60,
              width: 60,
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CUBOS',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: ExampleList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examples = [
      Example(
          'Cubo Mágico 2x2x2',
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nível: ',
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.grey),
              Icon(Icons.star, size: 16, color: Colors.grey),
              Icon(Icons.star, size: 16, color: Colors.grey),
            ],
          ),
          'assets/images/rubiks3x3x3.png',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocalObjectWidget(cube: '2x2x2')))),
      Example(
          'Cubo Mágico 3x3x3',
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nível: ',
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.grey),
              Icon(Icons.star, size: 16, color: Colors.grey),
            ],
          ),
          'assets/images/rubiks3x3x3.png',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocalObjectWidget(cube: '2x2x2')))),
    ];
    return Container(
      width: MediaQuery.of(context).size.width - 1,
      child: MediaQuery.removePadding(
        context: context,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: examples.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: ExampleCard(
                example: examples[index],
              ));
            }),
      ),
    );
  }
}

class ExampleCard extends StatelessWidget {
  final Example? example;
  ExampleCard({Key? key, this.example}) : super(key: key);

  @override
  build(BuildContext context) {
    return Card(
      color: Colors.black12,
      child: InkWell(
        onTap: () {
          example!.onTap();
        },
        child: Container(
          child: Expanded(
            child: Column(
              children: [
                Container(child: Image.asset(example!.imageUrl)),
                Expanded(
                    child: Text(example!.name,
                        style: TextStyle(
                          color: Colors.white,
                        ))),
                Expanded(child: example!.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Example {
  const Example(this.name, this.description, this.imageUrl, this.onTap);
  final String name;
  final Widget description;
  final String imageUrl;
  final Function onTap;
}
