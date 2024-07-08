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
    int total = await VendaDao().getTotalVendas();
    double soma = await VendaDao().getSomaPrecosVendas();
    List<String> ultimas = await VendaDao().getFrutasTotal();

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
        title: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.green,
          child: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
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
