import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/dates.dart';
import 'views/qadha_prayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://cnbugcpwkfyhbkxqvvvk.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuYnVnY3B3a2Z5aGJreHF2dnZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTI1OTg0MjQsImV4cCI6MjAwODE3NDQyNH0.gUhBqPyhGTo8YpxZbKfFqu0eU7cuPByIGfaq3D2Of48",
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salah Mate',
      theme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Salah Mate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List pages = [
    const DatesPage(),
    const QadhaPrayersPage(),
  ];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: GoogleFonts.abel(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(width: double.infinity),
            Expanded(
              child: pages[pageIndex],
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return NavigationBar(
                    selectedIndex: pageIndex,
                    onDestinationSelected: (value) {
                      pageIndex = value;
                      setState(() {});
                    },
                    destinations: const <Widget>[
                      NavigationDestination(
                          icon: Icon(Icons.home), label: "Home"),
                      NavigationDestination(
                          icon: Icon(Icons.hexagon), label: "Qadha")
                    ],
                  );
                } else {
                  return const Text("Hello");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
