import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ravestreamradioapp/colors.dart' as cl;
import 'package:ravestreamradioapp/commonwidgets.dart' as cw;
import 'package:ravestreamradioapp/databaseclasses.dart' as dbc;
import 'package:ravestreamradioapp/database.dart' as db;
import 'package:ravestreamradioapp/shared_state.dart';

class GroupCreationScreen extends StatelessWidget {
  const GroupCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> title = ValueNotifier<String>("");
    ValueNotifier<String> groupid = ValueNotifier<String>("");
    ValueNotifier<dynamic> design = ValueNotifier(null);
    ValueNotifier<Map<String, MaterialColor>?> custom_roles =
        ValueNotifier<Map<String, MaterialColor>?>(null);
    ValueNotifier<Map<DocumentReference, dynamic>> members_roles =
        ValueNotifier<Map<DocumentReference, dynamic>>({db.db.doc(currently_loggedin_as.value!.path) : "founder"});
    ValueNotifier<String?> description = ValueNotifier<String?>(null);
    ValueNotifier<File?> fileToUpload = ValueNotifier<File?>(null);
    return Scaffold(
      backgroundColor: cl.darkerGrey,
      appBar: AppBar(
        backgroundColor: cl.lighterGrey,
        title: Text("Create Group", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () async {
                dbc.Group createdGroup = dbc.Group(
                  title: title.value,
                  groupid: groupid.value,
                  design: design.value,
                  custom_roles: custom_roles.value,
                  members_roles: members_roles.value,
                  description: description.value,
                  image: fileToUpload.value
                );
                await db.uploadGroupToDB(createdGroup);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(cw.hintSnackBar("Group created"));
              },
              child: Text("Upload", style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
                title: Text("Give your group a name: ",
                    style: TextStyle(color: Colors.white)),
                trailing: ValueListenableBuilder(
                    valueListenable: title,
                    builder: (context, snapshot, foo) {
                      return TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => cw.SimpleStringEditDialog(
                                    to_notify: title));
                          },
                          child: Text(snapshot.isEmpty ? "Title" : snapshot,
                              style: TextStyle(color: Colors.white)));
                    })),
            ListTile(
                title: Text("Choose a unique id",
                    style: TextStyle(color: Colors.white)),
                subtitle: Text("This cannot be changed later",
                    style: TextStyle(color: Colors.white)),
                trailing: ValueListenableBuilder(
                    valueListenable: groupid,
                    builder: (context, snapshot, foo) {
                      return TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => cw.SimpleStringEditDialog(
                                    to_notify: groupid));
                          },
                          child: Text(snapshot.isEmpty ? "ID" : snapshot,
                              style: TextStyle(color: Colors.white)));
                    })),
            ListTile(
                title: Text("Describe your Group: ",
                    style: TextStyle(color: Colors.white)),
                trailing: ValueListenableBuilder(
                    valueListenable: description,
                    builder: (context, snapshot, foo) {
                      return TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => cw.SimpleStringEditDialog(
                                    to_notify: description));
                          },
                          child: Text("Edit description here",
                              style: TextStyle(color: Colors.white)));
                    })),
            ListTile(
                title: Text("Pick an Icon: ",
                    style: TextStyle(color: Colors.white)),
                trailing: ValueListenableBuilder(
                    valueListenable: fileToUpload,
                    builder: (context, snapshot, foo) {
                      return TextButton(
                          onPressed: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              File file = File(image.path);
                              fileToUpload.value = file;
                            }
                          },
                          child: Text(
                              fileToUpload.value == null
                                  ? "Upload"
                                  : "Image Uploaded.",
                              style: TextStyle(color: Colors.white)));
                    })),
          ],
        ),
      ),
    );
  }
}
