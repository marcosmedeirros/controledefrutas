import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalVendas = 0;
  double somaPrecos = 0.0;
  List<String> ultimasVendas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    int total = await VendaDao().getNumeroVendas();
    double soma = await VendaDao().getSomaPreco();
    List<String> ultimas = await VendaDao().getFrutasVendidas();

    setState(() {
      totalVendas = total;
      somaPrecos = soma;
      ultimasVendas = ultimas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
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
                  Positioned(
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
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Cadastrar Fruta'),
              onTap: () {
                Navigator.pushNamed(context, '/cadastrar_fruta');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Ver Frutas'),
              onTap: () {
                Navigator.pushNamed(context, '/ver_frutas');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Cadastrar Vendas'),
              onTap: () {
                Navigator.pushNamed(context, '/cadastrar_vendas');
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Ver Vendas'),
              onTap: () {
                Navigator.pushNamed(context, '/ver_vendas');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Valor Total de Vendas', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 8),
                      Text('R\$${somaPrecos.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Número de Vendas', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 8),
                      Text('$totalVendas', style: TextStyle(fontSize: 24, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Frutas mais Vendidas:', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.separated(
                itemCount: ultimasVendas.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  String venda = ultimasVendas[index];
                  int separatorIndex = venda.indexOf(':');
                  String nomeVenda = venda.substring(0, separatorIndex);
                  String valorVenda = venda.substring(separatorIndex + 1).trim();

                  return ListTile(
                    title: Text(nomeVenda),
                    trailing: Text(
                      valorVenda,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
