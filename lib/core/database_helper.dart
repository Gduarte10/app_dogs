import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> initDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        // Criação da tabela dogs
        db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
        // Criação da tabela pessoas
        return db.execute(
          'CREATE TABLE pessoas(id INTEGER PRIMARY KEY, nome TEXT NOT NULL, telefone TEXT, email TEXT, enderecoAvRua TEXT, enderecoNumero TEXT, enderecoCep TEXT, enderecoCidade TEXT, enderecoEstado TEXT)',
        );
      },
      version:
          1, // Mantenha a versão como 1 ou incremente se já houver um banco de dados existente
    );
  }
}
