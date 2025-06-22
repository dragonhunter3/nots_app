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
  final List<Color> _noteColors = [
    Colors.amber,
    Color(0xff50c878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent
  ];
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

  String _formateDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
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
          centerTitle: true),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final notes = _notes[index];
          final color = Color(int.parse(notes.color!));
          return GestureDetector(
            onTap: () async {
              // await Navigator.push(context, MaterialPageRoute(builder:(context) => ViewScreen(note:notes),));
              _loadNots();
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: color),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notes.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme(context)
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(notes.discription!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme(context).titleMedium),
                    Spacer(),
                    Text(
                      _formateDateTime(notes.dateTime!),
                      style: textTheme(context).titleSmall?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    )
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
              MaterialPageRoute(
                builder: (context) => AddEditScreen(),
              ));
          _loadNots();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
