import 'package:flutter/material.dart';
import 'package:noots_app/src/common/constants/global_variables.dart';
import 'package:noots_app/src/common/model/notes_model.dart';
import 'package:noots_app/src/core/darabase_helper/database_helper.dart';
import 'package:noots_app/src/featues/add_edit/add_edit_screen.dart';
import 'package:noots_app/src/featues/view_notes/view_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<NotesModel> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNots();
  }

  Future<void> _loadNots() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return '';
    final DateTime dt = DateTime.tryParse(dateTime) ?? DateTime.now();
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes App",
          style: textTheme(context)
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _notes.isEmpty
          ? Center(
              child: Text(
                'No notes yet!',
                style: textTheme(context).titleMedium,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final color = note.color != null
                    ? Color(int.tryParse(note.color!) ?? Colors.amber.value)
                    : Colors.amber;

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewNoteScreen(note: note),
                      ),
                    );
                    _loadNots();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: color,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title ?? 'No Title',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme(context)
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            note.discription ?? 'No Description',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme(context).titleMedium,
                          ),
                          const Spacer(),
                          Text(
                            _formatDateTime(note.dateTime),
                            style: textTheme(context).titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditScreen()),
          );
          _loadNots();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
