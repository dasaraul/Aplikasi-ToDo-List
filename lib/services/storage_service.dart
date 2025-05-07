// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class StorageService {
  // Key untuk penyimpanan di SharedPreferences
  static const String _todosKey = 'todos_data';

  // Menyimpan daftar todo ke dalam SharedPreferences
  Future<void> saveTodos(List<TodoItem> todos) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Konversi setiap objek TodoItem menjadi JSON string
      final List<String> jsonList = todos.map((todo) {
        return jsonEncode(todo.toJson());
      }).toList();

      // Simpan list JSON string ke SharedPreferences
      await prefs.setStringList(_todosKey, jsonList);
    } catch (e) {
      // Log error dan re-throw exception
      print('Error saving todos: $e');
      throw Exception('Gagal menyimpan data todo');
    }
  }

  // Memuat daftar todo dari SharedPreferences
  Future<List<TodoItem>> loadTodos() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Ambil list JSON string dari SharedPreferences
      final List<String>? jsonList = prefs.getStringList(_todosKey);

      // Jika tidak ada data, kembalikan list kosong
      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }

      // Konversi setiap JSON string menjadi objek TodoItem
      return jsonList.map((jsonString) {
        final Map<String, dynamic> json = jsonDecode(jsonString);
        return TodoItem.fromJson(json);
      }).toList();
    } catch (e) {
      // Log error dan re-throw exception
      print('Error loading todos: $e');
      throw Exception('Gagal memuat data todo');
    }
  }

  // Menghapus semua data todo dari SharedPreferences
  Future<void> clearTodos() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_todosKey);
    } catch (e) {
      print('Error clearing todos: $e');
      throw Exception('Gagal menghapus data todo');
    }
  }
}