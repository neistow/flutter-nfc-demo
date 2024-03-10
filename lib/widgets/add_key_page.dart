import 'package:flutter/material.dart';
import 'package:key_finder/models/key_tag.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../core/key_tag_storage.dart';
import 'search_loader.dart';

class AddKeyPage extends StatefulWidget {
  const AddKeyPage({super.key});

  @override
  State<AddKeyPage> createState() => _AddKeyPageState();
}

class _AddKeyPageState extends State<AddKeyPage> {
  final KeyTagStorage _storage = KeyTagStorage.instance;
  final _formKey = GlobalKey<FormState>();

  String? _keyName;
  String? _keyDescription;
  bool _scanning = false;

  @override
  void dispose() {
    super.dispose();
    NfcManager.instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new key'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_scanning)
              const Center(child: SearchLoader(loaderMessage: 'Move device to the tag to add it',))
            else
              _newKeyForm()
          ],
        ));
  }

  Widget _newKeyForm() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (val) {
                  _keyName = val;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter key name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                onSaved: (val) {
                  _keyDescription = val;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter key description',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _startWriteTagScan();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ));
  }

  cum
  
}
