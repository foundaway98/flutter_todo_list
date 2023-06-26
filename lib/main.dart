import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
        ),
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  List<String> tasks = [];
  List completeTaskFlags = [];

  bool isModifying = false;
  int modifyingIndex = 0;
  double percent = 0.0;

  String getToday() {
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(getToday()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _textController,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_textController.text == '') {
                            return;
                          }
                          isModifying
                              ? setState(() {
                                  tasks[modifyingIndex] = _textController.text;
                                  _textController.clear();
                                  modifyingIndex = 0;
                                  isModifying = false;
                                })
                              : setState(() {
                                  tasks.add(_textController.text);
                                  completeTaskFlags.add(0);
                                  _textController.clear();
                                });
                        },
                        child: Text(isModifying ? "modify" : "add"))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 14.0,
                      percent: percent,
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < tasks.length; i++)
                Row(
                  children: [
                    Flexible(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            int completeTaskCnt = 0;
                            completeTaskFlags[i] == 1
                                ? completeTaskFlags[i] = 0
                                : completeTaskFlags[i] = 1;

                            for (i in completeTaskFlags) {
                              if (i == 1) {
                                completeTaskCnt += 1;
                              }
                            }
                            percent = (completeTaskCnt / tasks.length);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              completeTaskFlags[i] == 1
                                  ? const Icon(Icons.check_box_rounded)
                                  : const Icon(
                                      Icons.check_box_outline_blank_rounded),
                              Text(tasks[i]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isModifying
                          ? null
                          : () {
                              setState(() {
                                isModifying = true;
                                _textController.text = tasks[i];
                                modifyingIndex = i;
                              });
                            },
                      child: const Text("수정"),
                    ),
                    TextButton(
                      onPressed: isModifying
                          ? null
                          : () {
                              setState(() {
                                tasks.remove(tasks[i]);
                                completeTaskFlags.remove(completeTaskFlags[i]);
                              });
                            },
                      child: const Text("삭제"),
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
