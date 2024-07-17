import 'package:controle_vendas_frutas/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/model/usuario.dart';
import 'package:controle_vendas_frutas/app-code/model/venda.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';
import 'package:controle_vendas_frutas/app-code/persistence/usuariodao.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';
import 'package:controle_vendas_frutas/screens/cadastrar_frutas.dart';
import 'package:controle_vendas_frutas/screens/cadastrar_vendas.dart';
import 'package:controle_vendas_frutas/screens/home.dart';
import 'package:controle_vendas_frutas/screens/login.dart';
import 'package:controle_vendas_frutas/screens/ver_frutas.dart';
import 'package:controle_vendas_frutas/screens/ver_vendas.dart';
import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/persistence/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await getDatabase();
  await _geraFrutas();
  await _gerarVendas();
  await _geraUsuario();

  runApp(MyApp());
}

Future<void> _geraUsuario() async {
  UsuarioDao().getUsuarios().then((value) {
    for (Usuario u in value) {
      debugPrint('Usuario nome: ' + u.nome);
    }
  });
}

Future<void> _geraFrutas() async {
  FrutaDao().getFrutas().then((value) {
    for (Fruta f in value) {
      debugPrint('Fruta nome: ' + f.nome);
    }
  });
}

Future<void> _gerarVendas() async {
  VendaDao().getVendas().then((value) {
    for (Venda v in value) {
      debugPrint('Venda cliente: ' + v.cliente);
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Fruti',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/cadastrar_fruta': (context) => CadastrarFrutas(),
        '/ver_frutas': (context) => VerFrutas(),
        '/cadastrar_vendas': (context) => CadastrarVendas(),
        '/ver_vendas': (context) => VerVendas(),
      },
    );
  }
}
