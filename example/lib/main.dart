import 'package:flutter/material.dart';
import 'package:load_state_layout/load_state_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  ///页面加载状态，默认为加载中
  LayoutController layoutController =
      LayoutController(layoutState: LayoutState.loading);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    layoutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  layoutController.layoutState = LayoutState.success;
                },
                child: const Text("成功"),
              ),
              TextButton(
                onPressed: () {
                  layoutController.layoutState = LayoutState.loading;
                },
                child: const Text("loading"),
              ),
              TextButton(
                onPressed: () {
                  layoutController.layoutState = LayoutState.empty;
                },
                child: const Text("空页面"),
              ),
              TextButton(
                onPressed: () {
                  layoutController.layoutState = LayoutState.error;
                },
                child: const Text("错误页面"),
              ),
            ],
          ),
          Expanded(
            child: LoadStateLayout(
              layoutController: layoutController,
              errorRetry: () {
                layoutController.layoutState = LayoutState.loading;
              }, //错误按钮点击过后进行重新加载
              successWidget: const Text("正文"),
            ),
          ),
        ],
      ),
    );
  }
}
