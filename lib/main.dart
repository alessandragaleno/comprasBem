import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: RegistrationScreen(),
    );
  }
}

// classe para manipular o banco de dados SQLite
class DatabaseHelper {
  static Database? _database;
  static final _databaseHelper instance = databaseHelper._init();

  DatabaseHelper._init();

  // Inicializa o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

// Criação do banco de dados e tabelas
Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);

  print("Caminho do banco de dados: $path"); //exibe o caminho do banco de dados n console

  return await openDatabase(path, version: 1, onCreate: _createDB);

}

Future _createDB(Database sb, int version) async {
  await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TXT UNIQUE,
      email TXT,
      phone TXT,
      password TXT
    )
''')
await db.execute('''
  CREATE TABLE shopping_lists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    name TXT,
    items TXT,
    FOREIGN KEY (user_id) REFERENCES users (id)
  )
''');
// log para confirmar a criação do banco