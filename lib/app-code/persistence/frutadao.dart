import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class FrutaDao {
  static const String _tableName = 'frutas';
  static const String _colId = 'id';
  static const String _colNome = 'nome';
  static const String _colPreco = 'preco';

  String sqlTableFrutas = '''
    CREATE TABLE $_tableName(
      $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_colNome TEXT,
      $_colPreco REAL
    )
  ''';

  Future<void> adicionar(Fruta fruta) async {
    final Database db = await getDatabase();
    await db.insert(_tableName, fruta.toMap());
  }

  Future<void> deletar(int? id) async {
    final Database db = await getDatabase();
    await db.delete(
      _tableName,
      where: '$_colId = ?',
      whereArgs: [id!],
    );
  }


  Future<List<Fruta>> getFrutas() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Fruta(
        id: maps[i][_colId],
        nome: maps[i][_colNome],
        preco: maps[i][_colPreco],
      );
    });
  }

  Future<bool> atualizar(Fruta fruta) async {
    final Database db = await getDatabase();
    int rowsAffected = await db.update(
      _tableName,
      fruta.toMap(),
      where: '$_colId = ?',
      whereArgs: [fruta.id],
    );
    return rowsAffected > 0;
  }
}
