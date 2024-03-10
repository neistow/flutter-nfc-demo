import 'package:flutter/material.dart';

import '../core/key_tag_storage.dart';
import '../models/key_tag.dart';

class KeysList extends StatelessWidget {
  final KeyTagStorage storage = KeyTagStorage.instance;

  final List<KeyTagModel> keys;
  final VoidCallback onItemDeleted;

  KeysList({super.key, required this.keys, required this.onItemDeleted});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      for (final keyTag in keys)
        Dismissible(
            key: ValueKey(keyTag.id),
            background: Container(
                color: Colors.red.withOpacity(0.15),
                child: const Icon(Icons.delete)),
            child: ListTile(
              title: Text(keyTag.name),
              subtitle: Text(keyTag.description),
            ),
            confirmDismiss: (_) async {
              final keyDeleted = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete key'),
                    content:
                    Text("Do you want to delete key ${keyTag.name}?"),
                    actions: [
                      TextButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true)
                                  .pop(true),
                          child: const Text("Yeah")),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true)
                                .pop(false),
                        child: const Text("Nah"),
                      )
                    ],
                  ));

              if(!keyDeleted) {
                return;
              }

              await storage.delete(keyTag.id);
              onItemDeleted();
            })
    ]);
  }
}
