import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  Notes();

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Notes')
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(15),
                child: new NotesFieldBuilder(),
              )
          )
      ),
    );
  }
}

class NoteFieldBuilder extends StatelessWidget {
  NoteFieldBuilder();

  @override
  Widget build(BuildContext context) {
   final note = Provider.of<Notes>(context, listen: false).getActiveNotes; //got an error couldnt solve

    String title = note?.title ?? "";
    String message = note?.message ?? "";

    final titleController = TextEditingController(text: title);
    final messageController = TextEditingController(text: message);

    return
      Column(
        children: <Widget>[
          TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'Add a title',
                  labelText: 'Title'
              ),
              validator: (value) {
                if (value.isEmpty){
                  return "Take note here";
                }
                return "Blank";
              }
          ),
          TextFormField(
            controller: messageController,
            decoration: const InputDecoration(
                hintText: 'Talk about something!',
                labelText: 'Message'
            ),
            validator: (value) {
              if (value.isEmpty){
                return "Please enter some text";
              }
              return null;
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              final notesModel = context.read<Notes>();

              String title = titleController.text;
              String message = messageController.text;

              bool isCreating = (note?.id == null);

              if (isCreating){
                notesModel.createNewNote({
                  "title": title,
                  "message": message
                });
              } else {
                Notes activeNotes = Provider.of<Notes>(context, listen: false).getActiveNotes;

                activeNotes.title = title;
                activeNotes.message = message;

                await Provider.of<Notes>(context, listen: false).saveActiveNoteEdits();
              }

              Navigator.pop(context);
            },
          ),
        ],
      );
  }
}

