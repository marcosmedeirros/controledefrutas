import 'package:controle_vendas_frutas/app-code/model/venda.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';
import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';
import 'package:controle_vendas_frutas/app-code/persistence/database.dart'; // Importar o arquivo database.dart
import 'screens/cadastrar_frutas.dart';
import 'screens/ver_frutas.dart';
import 'screens/cadastrar_vendas.dart';
import 'screens/ver_vendas.dart';
import 'screens/home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await getDatabase();
  await _geraFrutas();
  await _gerarVendas();

  runApp(MyApp());
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
      debugPrint('Venda nome: ' + v.cliente);
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    AdicionarFrutaScreen(),
    VerFrutas(),
    CadastrarVendas(),
    VerVendas(),
  ];

  void _onItemTapped(int index) {
    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context);
    } else {
      print("Index fora do intervalo válido: $index");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle Fruti'),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    right: 16.0,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Cadastrar Fruta'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Ver Frutas'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Cadastrar Vendas'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Ver Vendas'),
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
