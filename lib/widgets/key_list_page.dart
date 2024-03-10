import 'package:flutter/material.dart';
import 'package:key_finder/core/key_tag_storage.dart';
import 'package:key_finder/widgets/add_key_page.dart';
import 'package:key_finder/widgets/search_keys_page.dart';

import '../models/key_tag.dart';
import 'key_list.dart';

class KeysListPage extends StatefulWidget {
  const KeysListPage({super.key});

  @override
  State<KeysListPage> createState() => _KeysListPageState();
}

class _KeysListPageState extends State<KeysListPage> {
  final KeyTagStorage storage = KeyTagStorage.instance;

  List<KeyTagModel> keys = [];

  @override
  void initState() {
    refreshKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Your keys'),
              backgroundColor: Colors.blueAccent,
            ),
            body: SafeArea(
                child: KeysList(
              keys: keys,
              onItemDeleted: refreshKeys,
            )),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'search',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const SearchKeysPage()),
                    );
                  },
                  child: const Icon(Icons.search),
                ),
                const SizedBox(width: 25),
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => const AddKeyPage()),
                    );
                    refreshKeys();
                  },
                  child: const Icon(Icons.add),
                )
              ],
            )));
  }

  refreshKeys() async {
    final items = await storage.getAll();
    setState(() {
      keys = items;
    });
  }
}
