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
  bool _loading = false;

  Future<void> _loadTodos() async {
    print('SELECT...');

    final user = supabase.auth.currentUser;
    if (user == null) {
      print('SELECT ERROR: user is null (не залогинен)');
      setState(() {
        _todos = [];
      });
      return;
    }

    setState(() => _loading = true);
    try {
      final data = await supabase
          .from('todos')
          .select()
          .eq('user_id', user.id) as List<dynamic>;

      _todos = data.cast<Map<String, dynamic>>();
      print('SELECT received: $_todos');
    } catch (e) {
      print('SELECT ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  Future<void> _showAddTodoDialog() async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Новая задача'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Название',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(context, text);
            },
            child: const Text('Добавить'),
          ),
        ],
      );
    },
  ).then((value) {
    if (value != null && value is String && value.isNotEmpty) {
      _addTodoWithTitle(value);
    }
  });
}

  Future<void> _addTodo() async {
    print('INSERT...');
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('INSERT ERROR: user is null');
      return;
    }

    try {
      final inserted = await supabase.from('todos').insert({
        'title': 'Новая задача ${DateTime.now().toLocal()}',
        'is_done': false,
        'user_id': user.id,
      }).select();

      print('INSERT result: $inserted');
      _loadTodos();
    } catch (e) {
      print('INSERT ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка добавления: $e')),
        );
      }
    }
  }

  Future<void> _addTodoWithTitle(String title) async {
  print('INSERT with title=$title');

  final user = supabase.auth.currentUser;
  if (user == null) {
    print('INSERT ERROR: user is null');
    return;
  }

  try {
    final inserted = await supabase.from('todos').insert({
      'title': title,
      'is_done': false,
      'user_id': user.id,
    }).select();

    print('INSERT result: $inserted');
    _loadTodos();
  } catch (e) {
    print('INSERT ERROR: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка добавления: $e')),
      );
    }
  }
}

  Future<void> _updateFirstTodo() async {
    if (_todos.isEmpty) {
      print('UPDATE: нет записей');
      return;
    }
    final id = _todos.first['id'];
    print('UPDATE id=$id...');

    try {
      final updated = await supabase
          .from('todos')
          .update({'is_done': true})
          .eq('id', id)
          .select();
      print('UPDATE result: $updated');
      _loadTodos();
    } catch (e) {
      print('UPDATE ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления: $e')),
        );
      }
    }
  }

  Future<void> _deleteFirstTodo() async {
    if (_todos.isEmpty) {
      print('DELETE: нет записей');
      return;
    }
    final id = _todos.first['id'];
    print('DELETE id=$id...');

    try {
      final deleted =
          await supabase.from('todos').delete().eq('id', id).select();
      print('DELETE result: $deleted');
      _loadTodos();
    } catch (e) {
      print('DELETE ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления: $e')),
        );
      }
    }
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
    final total = _todos.length;
    final done = _todos.where((t) => t['is_done'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Supabase Demo'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddTodoDialog,
          icon: const Icon(Icons.add),
          label: const Text('Новая задача'),
        ),
      body: SafeArea(
        child: Column(
          children: [
            // Верхний блок с инфой
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.storage, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Твои задачи в Supabase',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Всего: $total · Выполнено: $done',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _loadTodos,
                        tooltip: 'Обновить',
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Кнопки CRUD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _loadTodos,
                        icon: const Icon(Icons.download),
                        label: const Text('SELECT'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _updateFirstTodo,
                        icon: const Icon(Icons.done),
                        label: const Text('UPDATE 1'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _deleteFirstTodo,
                        icon: const Icon(Icons.delete),
                        label: const Text('DELETE 1'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Список задач
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _todos.isEmpty
                      ? const Center(
                          child: Text(
                            'Задач пока нет.\nНажми на кнопку снизу, чтобы добавить.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _todos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final todo = _todos[i];

                            // Поддержка и 'title', и 'title text'
                            final title =
                                (todo['title'] ?? todo['title text'] ?? '')
                                    .toString();
                            final isDone = todo['is_done'] == true;

                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  isDone
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: isDone
                                      ? Colors.green
                                      : Colors.grey[500],
                                ),
                                title: Text(
                                  title,
                                  style: TextStyle(
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Text('id: ${todo['id']}'),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
