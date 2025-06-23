import 'package:flutter/material.dart';
import 'package:noots_app/src/common/constants/global_variables.dart';
import 'package:noots_app/src/common/model/notes_model.dart';
import 'package:noots_app/src/common/widgets/custom_button.dart';
import 'package:noots_app/src/common/widgets/custom_textfield.dart';
import 'package:noots_app/src/core/darabase_helper/database_helper.dart';

class AddEditScreen extends StatefulWidget {
  final NotesModel? notes;
  const AddEditScreen({super.key, this.notes});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Color selectedColor = Colors.amber;

  final List<Color> noteColors = [
    Colors.amber,
    Color(0xff50c878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.notes != null) {
      titleController.text = widget.notes!.title ?? '';
      descriptionController.text = widget.notes!.discription ?? '';
      selectedColor = Color(int.parse(widget.notes!.color!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.notes != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Note" : "Add Note",
          style: textTheme(context).headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                controller: titleController,
                hint: "Enter Title",
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: descriptionController,
                hint: "Enter Description",
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text("Select Color", style: textTheme(context).titleSmall),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: noteColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: color,
                          child: selectedColor == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 25),
              CustomButton(
                onTap: _saveNote,
                text: isEdit ? "Update Note" : "Save Note",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = NotesModel(
        id: widget.notes?.id,
        title: titleController.text.trim(),
        discription: descriptionController.text.trim(),
        color: selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),
      );

      if (widget.notes == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }

      if (mounted) Navigator.pop(context); // Go back only after successful save
    }
  }
}
