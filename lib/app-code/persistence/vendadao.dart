import 'package:controle_vendas_frutas/app-code/model/venda.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class VendaDao {
  static const String _tableName = 'vendas';
  static const String _colIdVenda = 'idVenda';
  static const String _colCliente = 'cliente';
  static const String _colFruta = 'fruta';
  static const String _colPeso = 'peso';
  static const String _colValor = 'valor';

   String sqlTableVendas = 'CREATE TABLE $_tableName('
      '$_colIdVenda INTEGER PRIMARY KEY,'
      '$_colCliente TEXT,'
      '$_colFruta TEXT,'
      '$_colPeso REAL,'
      '$_colValor REAL'
      ')';


  Future<void> adicionar(Venda venda) async {
    final Database db = await getDatabase();
    await db.insert(_tableName, venda.toMap());
  }

  Future<void> deletar(int? idVenda) async {
    final Database db = await getDatabase();
    await db.delete(
      _tableName,
      where: '$_colIdVenda = ?',
      whereArgs: [idVenda!],
    );
  }


  Future<List<Venda>> getVendas() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Venda(
        idVenda: maps[i][_colIdVenda],
        cliente: maps[i][_colCliente],
        fruta: maps[i][_colFruta],
        peso: double.tryParse(maps[i][_colPeso]) ?? 0.0,
        valor: double.tryParse(maps[i][_colValor]) ?? 0.0,
      );
    });
  }

  Future<bool> atualizar(Venda venda) async {
    final Database db = await getDatabase();
    int rowsAffected = await db.update(
      _tableName,
      venda.toMap(),
      where: '$_colIdVenda = ?',
      whereArgs: [venda.idVenda],
    );
    return rowsAffected > 0;
  }


  Future<int> getTotalVendas() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) AS total FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getSomaPrecosVendas() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM($_colValor) AS soma FROM $_tableName');
    double soma = result[0]['soma'] ?? 0.0;
    return soma;
  }

  Future<List<String>> getFrutasTotal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT $_colFruta, SUM($_colValor) AS valorTotal
      FROM $_tableName
      GROUP BY $_colFruta
      ORDER BY valorTotal DESC
      LIMIT 6
    ''');

    List<String> ultimasVendas = [];
    for (var map in result) {
      String nomeFruta = map[_colFruta];
      double valorTotal = map['valorTotal'];
      ultimasVendas.add('$nomeFruta: R\$$valorTotal');
    }

    return ultimasVendas;
  }
}