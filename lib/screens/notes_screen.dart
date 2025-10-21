// ...existing code...
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // Function to fetch notes from the database
  Future<void> _fetchNotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final fetchedNotes = await _noteService.getNotes();

      setState(() {
        _notes = fetchedNotes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        _error = 'Failed to load notes. Please try again.';
        _isLoading = false;
      });
    }
  }

  // Show the add note dialog
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        onNoteAdded: _handleNoteAdded,
      ),
    );
  }

  // Add the new note to the state and avoid refetching
  void _handleNoteAdded(Map<String, dynamic> noteData) {
    // Extract id robustly (accept both 'id' and '$id')
    final String docId =
        (noteData['id']?.toString() ?? noteData[r'$id']?.toString()) ?? 'temp-id';

    final newNote = Document(
      $id: docId,
      $collectionId: noteData[r'$collectionId']?.toString() ?? 'notes',
      $databaseId: noteData[r'$databaseId']?.toString() ?? 'NotesDB',
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $permissions: <dynamic>[],
      data: noteData,
    );

    setState(() {
      _notes = [newNote, ..._notes];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Notes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddNoteDialog,
                  child: const Text('+ Add Note'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show loading indicator
            if (_isLoading && _notes.isEmpty)
              const Center(child: CircularProgressIndicator()),

            // Show error message
            if (_error != null && _notes.isEmpty)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            // Notes list or empty state
            if (_notes.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchNotes,
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return NoteItem(note: _notes[index]);
                    },
                  ),
                ),
              )
            else if (!_isLoading && _error == null)
              const Expanded(
                child: Center(
                  child: Text('No notes yet. Tap + Add Note to create one.'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// ...existing code...