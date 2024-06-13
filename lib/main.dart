import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'views/home_screen.dart';
import 'views/meditation_screen.dart';
import 'views/mood_tracker_screen.dart';
import 'views/mood_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: _initializeDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error initializing database')),
            ),
          );
        } else {
          return MaterialApp(
            title: 'SAU',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(
                color: Colors.blue,
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blue,
                textTheme: ButtonTextTheme.primary,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blueGrey[900],
              scaffoldBackgroundColor: Colors.blueGrey[900],
              appBarTheme: AppBarTheme(
                color: Colors.blueGrey[800],
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blueGrey[700],
                textTheme: ButtonTextTheme.primary,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.blueGrey[800],
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.white70,
              ),
            ),
            themeMode: ThemeMode.dark,
            home: MainScreen(database: snapshot.data!),
          );
        }
      },
    );
  }

  Future<Database> _initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'sau_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE moods(id INTEGER PRIMARY KEY, mood TEXT, date TEXT)",
        );
      },
      version: 1,
    );
  }
}

class MainScreen extends StatefulWidget {
  final Database database;

  MainScreen({required this.database});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(),
      MeditationScreen(videoUrl: 'https://www.youtube.com/watch?v=RylLBe8yAwc'),
      MoodTrackerScreen(database: widget.database),
      MoodHistoryScreen(database: widget.database),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Meditação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Humor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
