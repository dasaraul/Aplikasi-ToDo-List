import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk TextField
  final TextEditingController _todoController = TextEditingController();
  
  // List untuk menyimpan semua tugas
  List<TodoItem> _todoItems = [];
  
  // Service untuk menyimpan data
  final StorageService _storageService = StorageService();
  
  // Objek untuk generate id unik
  final Uuid _uuid = const Uuid();
  
  // Menandai apakah sedang loading data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  // Memuat data to-do list dari penyimpanan
  Future<void> _loadTodos() async {
    try {
      final todos = await _storageService.loadTodos();
      setState(() {
        _todoItems = todos;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading todos: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Gagal memuat data tugas');
    }
  }

  // Menambahkan tugas baru
  Future<void> _addTodo() async {
    final String title = _todoController.text.trim();
    
    // Validasi judul tugas tidak boleh kosong
    if (title.isEmpty) {
      _showErrorSnackBar('Judul tugas tidak boleh kosong');
      return;
    }

    // Membuat objek tugas baru
    final newTodo = TodoItem(
      id: _uuid.v4(),
      judul: title,
      tanggalDibuat: DateTime.now(),
    );

    setState(() {
      _todoItems.add(newTodo);
      _todoController.clear();
    });

    // Menyimpan perubahan ke penyimpanan
    await _storageService.saveTodos(_todoItems);
    
    _showSuccessSnackBar('Tugas baru berhasil ditambahkan');
  }

  // Menandai tugas sebagai selesai atau belum selesai
  Future<void> _toggleTodoStatus(String id) async {
    final index = _todoItems.indexWhere((item) => item.id == id);
    
    if (index != -1) {
      setState(() {
        // Membalik status tugas
        final currentStatus = _todoItems[index].selesai;
        _todoItems[index] = _todoItems[index].copyWith(
          selesai: !currentStatus,
          tanggalSelesai: !currentStatus ? DateTime.now() : null,
        );
      });

      // Menyimpan perubahan ke penyimpanan
      await _storageService.saveTodos(_todoItems);
    }
  }

  // Menghapus tugas
  Future<void> _deleteTodo(String id) async {
    setState(() {
      _todoItems.removeWhere((item) => item.id == id);
    });

    // Menyimpan perubahan ke penyimpanan
    await _storageService.saveTodos(_todoItems);
    
    _showSuccessSnackBar('Tugas berhasil dihapus');
  }

  // Menampilkan snackbar error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  // Menampilkan snackbar sukses
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'To-Do List App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAboutDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : Column(
              children: [
                // Input area
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // TextField untuk input tugas baru
                      Expanded(
                        child: TextField(
                          controller: _todoController,
                          decoration: InputDecoration(
                            hintText: 'Tambahkan tugas baru',
                            hintStyle: TextStyle(
                              color: theme.colorScheme.onBackground.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.task_alt,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          onSubmitted: (_) => _addTodo(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol untuk menambahkan tugas
                      ElevatedButton(
                        onPressed: _addTodo,
                        child: const Text(
                          'Tambah',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.onBackground.withOpacity(0.1),
                ),
                
                // List tugas
                Expanded(
                  child: _todoItems.isEmpty
                      ? _buildEmptyState()
                      : _buildTodoList(),
                ),
                
                // Footer dengan copyright
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  child: Text(
                    '© 2025 Tuti Hastuti',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Widget untuk menampilkan jika tidak ada tugas
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada tugas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan tugas baru sekarang!',
            style: TextStyle(
              color: theme.colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan daftar tugas
  Widget _buildTodoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        final todo = _todoItems[index];
        return _buildTodoItem(todo);
      },
    );
  }

  // Widget untuk menampilkan satu item tugas
  Widget _buildTodoItem(TodoItem todo) {
    final theme = Theme.of(context);
    
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => _deleteTodo(todo.id),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Checkbox(
            value: todo.selesai,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (_) => _toggleTodoStatus(todo.id),
          ),
          title: Text(
            todo.judul,
            style: TextStyle(
              decoration: todo.selesai ? TextDecoration.lineThrough : null,
              color: todo.selesai
                  ? theme.colorScheme.onBackground.withOpacity(0.5)
                  : theme.colorScheme.onBackground,
              fontWeight: todo.selesai ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            todo.selesai
                ? 'Selesai pada: ${_formatDateTime(todo.tanggalSelesai)}'
                : 'Dibuat pada: ${_formatDateTime(todo.tanggalDibuat)}',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red[400],
            ),
            onPressed: () => _deleteTodo(todo.id),
          ),
        ),
      ),
    );
  }

  // Menampilkan dialog tentang aplikasi
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tentang Aplikasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To-Do List App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aplikasi sederhana untuk mengelola daftar tugas Anda. Tambahkan, tandai selesai, dan hapus tugas dengan mudah.',
              ),
              const SizedBox(height: 16),
              Text(
                '© 2025 Tuti Hastuti',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Format tanggal dan waktu untuk ditampilkan
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    
    String _addLeadingZero(int value) {
      return value < 10 ? '0$value' : '$value';
    }
    
    return '${_addLeadingZero(dateTime.day)}/${_addLeadingZero(dateTime.month)}/${dateTime.year} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}';
  }
}