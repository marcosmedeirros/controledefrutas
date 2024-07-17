import 'package:controle_vendas_frutas/app-code/persistence/usuariodao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'frutasbanco021.db');
  debugPrint('Caminho do banco de dados: $path');

  return openDatabase(
    path,
    onCreate: (db, version) {
      debugPrint('Criando a tabela de usuarios...');
      db.execute(UsuarioDao().sqlTableUsuario);
      debugPrint('Criando a tabela de frutas...');
      db.execute(FrutaDao().sqlTableFrutas);
      debugPrint('Criando a tabela de vendas...');
      db.execute(VendaDao().sqlTableVendas);

    },
    version: 1);
}
