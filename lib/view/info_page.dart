import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoPage extends ConsumerStatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  createState() => _InfoPage();
}

class _InfoPage extends ConsumerState<InfoPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Text('Created by Corjan Bos, 2023'),
                const Text('Version 0.14'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 1, child: Text('Suggestions ')),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        maxLines: 8, //or null
                        decoration: InputDecoration(hintText: "Enter your text here", border: OutlineInputBorder())),
                    ),
                ],),
              const SizedBox(height: 10,),
              Center(child: SizedBox(width: 150, child: FloatingActionButton(onPressed: () {}, shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))), child: const Text('Send message'),)))
            ],),
    );
  }
}
