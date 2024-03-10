import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../core/key_tag_storage.dart';
import 'search_loader.dart';

class SearchKeysPage extends StatefulWidget {
  const SearchKeysPage({super.key});

  @override
  State<SearchKeysPage> createState() => _SearchKeysPageState();
}

class _SearchKeysPageState extends State<SearchKeysPage> {
  final KeyTagStorage storage = KeyTagStorage.instance;

  String? message;

  @override
  void initState() {
    super.initState();
    startTagScan();
  }

  @override
  void dispose() {
    super.dispose();
    NfcManager.instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search keys'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
          child: message == null
              ? const SearchLoader(loaderMessage: 'Searching for nearby tags')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message!),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: startTagScan,
                        child: const Text('Scan again'))
                  ],
                )),
    );
  }

  startTagScan() {
    setState(() {
      message = null;
    });

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      final ndef = Ndef.from(tag);
      if (ndef == null) {
        message = "Can't read NFC tag";
        return;
      }

      final id = ndef.additionalData['identifier']
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join(':')
          .toString()
          .toUpperCase();

      final keyTagModel = await storage.getById(id);
      if (keyTagModel == null) {
        setState(() {
          message = "Key tag wasn't found in db :(";
        });
      } else {
        setState(() {
          message = "${keyTagModel.name}\n${keyTagModel.description}";
        });
      }

      NfcManager.instance.stopSession();
    });
  }
}
