import 'package:flutter/material.dart';
import 'package:hive_riverpod/note_model.dart';
import 'package:hive_riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:math' as math;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

final TitleController = TextEditingController();
final SubtitleController = TextEditingController();

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    ref.read(HiveDbProvider).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boxnote = ref.watch(BoxNoteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("riverpod with hive"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: boxnote.listenable(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          final List<Note> noteList =
              ref.watch(BoxNoteProvider).values.toList().cast<Note>();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "write your title",
                      prefixIcon: Icon(Icons.title)),
                  controller: TitleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "write your subtitle",
                      prefixIcon: Icon(Icons.subtitles)),
                  controller: SubtitleController,
                ),
              ),
              TextButton(
                  onPressed: () {
                    ref.read(HiveDbProvider).ClearNote();
                  },
                  child: const Text("clear")),
              Expanded(
                child: ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(noteList[index].title),
                      subtitle: Text(noteList[index].subtitle),
                      trailing: IconButton(
                          onPressed: () {
                            ref.read(HiveDbProvider).DelateNote(index);
                          },
                          icon: const Icon(Icons.delete)),
                      onTap: () {
                        ref.read(HiveDbProvider).putNote(
                            Note(
                                title: TitleController.text,
                                subtitle: SubtitleController.text,
                                id: math.Random().nextInt(10000).toString()),
                            index);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          boxnote.add(Note(
              title: "null Box",
              subtitle: "null box",
              id: math.Random().nextInt(10000).toString()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
