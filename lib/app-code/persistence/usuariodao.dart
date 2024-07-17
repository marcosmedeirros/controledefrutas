import 'package:controle_vendas_frutas/app-code/model/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';
import '../model/fruta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioDao {
  static const String _tableName = 'usuarios';
  static const String _colidUsuario = 'idUsuario';
  static const String _colNome = 'nome';
  static const String _colEmail = 'email';
  static const String _colSenha = 'senha';

  String sqlTableUsuario = 'CREATE TABLE $_tableName('
      '$_colidUsuario INTEGER PRIMARY KEY,'
      '$_colNome TEXT,'
      '$_colEmail TEXT,'
      '$_colSenha TEXT'
      ')';


  Future<void> adicionar(Usuario usuario) async {
    final Database db = await getDatabase();
    await db.insert(_tableName, usuario.toMap());
  }

  Future<void> deletar(int? id) async {
    final Database db = await getDatabase();
    await db.delete(
      _tableName,
      where: '$_colidUsuario = ?',
      whereArgs: [id!],
    );
  }

  Future<List<Usuario>> getUsuarios() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Usuario(
        idUsuario: maps[i][_colidUsuario],
        nome: maps[i][_colNome],
        email: maps[i][_colEmail],
        senha: maps[i][_colSenha],
      );
    });
  }

  Future<bool> atualizar(Usuario usuario) async {
    final Database db = await getDatabase();
    int rowsAffected = await db.update(
      _tableName,
      usuario.toMap(),
      where: '$_colidUsuario = ?',
      whereArgs: [usuario.idUsuario],
    );
    return rowsAffected > 0;
  }

  Future<Usuario?> fazerLogin(String email, String senha) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_colEmail = ? AND $_colSenha = ?',
      whereArgs: [email, senha],
    );

    if (maps.isNotEmpty) {
      return Usuario(
        idUsuario: maps[0][_colidUsuario],
        nome: maps[0][_colNome],
        email: maps[0][_colEmail],
        senha: maps[0][_colSenha],
      );
    } else {
      return null;
    }
  }




}
