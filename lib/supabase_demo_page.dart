import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

final supabase = Supabase.instance.client;

class SupabaseDemoPage extends StatefulWidget {
  const SupabaseDemoPage({super.key});

  @override
  State<SupabaseDemoPage> createState() => _SupabaseDemoPageState();
}

class _SupabaseDemoPageState extends State<SupabaseDemoPage> {
  List<Map<String, dynamic>> _todos = [];

  Future<void> _loadTodos() async {
    print('SELECT...');
    final data = await supabase.from('todos').select();
    _todos = data.cast<Map<String, dynamic>>();
    print('SELECT received: $_todos');
    setState(() {});
  }

Future<void> _addTodo() async {
  print('INSERT...');

  final user = supabase.auth.currentUser;
  if (user == null) {
    print('INSERT ERROR: user is null (не залогинен)');
    return;
  }

  final inserted = await supabase.from('todos').insert({
    'title': 'New task ${DateTime.now()}',
    'is_done': false,
    'user_id': user.id,
  }).select();

  print('INSERT result: $inserted');
  _loadTodos();
}

  Future<void> _updateFirstTodo() async {
    if (_todos.isEmpty) {
      print('UPDATE: нет записей');
      return;
    }
    final id = _todos.first['id'];
    print('UPDATE id=$id...');
    final updated = await supabase
        .from('todos')
        .update({'is_done': true})
        .eq('id', id)
        .select();
    print('UPDATE result: $updated');
    _loadTodos();
  }

  Future<void> _deleteFirstTodo() async {
    if (_todos.isEmpty) {
      print('DELETE: нет записей');
      return;
    }
    final id = _todos.first['id'];
    print('DELETE id=$id...');
    final deleted =
        await supabase.from('todos').delete().eq('id', id).select();
    print('DELETE result: $deleted');
    _loadTodos();
  }

  Future<void> _signOut() async {
    print('AUTH: signOut...');
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase CRUD'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _loadTodos,
                  child: const Text('SELECT'),
                ),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('INSERT'),
                ),
                ElevatedButton(
                  onPressed: _updateFirstTodo,
                  child: const Text('UPDATE'),
                ),
                ElevatedButton(
                  onPressed: _deleteFirstTodo,
                  child: const Text('DELETE'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (_, i) {
                final todo = _todos[i];
                final title = (todo['title'] ?? todo['title text'] ?? '')
                    .toString();

                return ListTile(
                  title: Text(title),
                  subtitle: Text('id: ${todo['id']}'),
                  trailing: Icon(
                    todo['is_done'] == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
