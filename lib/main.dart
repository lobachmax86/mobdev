import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ztjpeugljsmaamgzbecs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0anBldWdsanNtYWFtZ3piZWNzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNjc1NTIsImV4cCI6MjA3OTk0MzU1Mn0.2xXTYiqQZt0XzjRYBqF06WSKd7AWftAJqRSl8nPEHfk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
