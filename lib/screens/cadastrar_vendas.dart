import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';
import 'package:controle_vendas_frutas/app-code/model/venda.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';

class CadastrarVendas extends StatefulWidget {
  @override
  _CadastrarVendasState createState() => _CadastrarVendasState();
}

class _CadastrarVendasState extends State<CadastrarVendas> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  Fruta? _frutaSelecionada;
  List<Fruta> _frutas = [];

  @override
  void initState() {
    super.initState();
    _carregarFrutas();
    _pesoController.addListener(_atualizarValor);
  }

  Future<void> _carregarFrutas() async {
    List<Fruta> frutas = await FrutaDao().getFrutas();
    setState(() {
      _frutas = frutas;
    });
  }

  void _atualizarValor() {
    if (_frutaSelecionada != null && _pesoController.text.isNotEmpty) {
      double quantidade = double.tryParse(_pesoController.text) ?? 0.0;
      setState(() {
        _valorController.text =
            (quantidade * _frutaSelecionada!.preco).toStringAsFixed(2);
      });
    }
  }

  Future<void> _cadastrarVenda() async {
    if (_frutaSelecionada != null) {
      if (_clienteController.text.isNotEmpty &&
          _pesoController.text.isNotEmpty &&
          _valorController.text.isNotEmpty) {
        Venda venda = Venda(
          cliente: _clienteController.text,
          fruta: _frutaSelecionada!.nome,
          peso: double.parse(_pesoController.text),
          valor: double.parse(_valorController.text),
          data: DateTime.now(),
          id: '',
        );

        try {
          await VendaDao().adicionar(venda);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Venda cadastrada com sucesso no Firebase!')),
          );
          _clienteController.clear();
          _pesoController.clear();
          _valorController.clear();
          setState(() {
            _frutaSelecionada = null;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao cadastrar venda no Firebase: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha todos os campos')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione uma fruta')),
      );
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _pesoController.dispose();
    _valorController.dispose();
    _pesoController.removeListener(_atualizarValor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Venda'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Cadastrar Fruta'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/cadastrar_fruta');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Ver Frutas'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ver_frutas');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Cadastrar Vendas'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Ver Vendas'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ver_vendas');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _clienteController,
              decoration: InputDecoration(labelText: 'Cliente'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Fruta>(
              decoration: InputDecoration(
                labelText: 'Fruta',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              value: _frutaSelecionada,
              onChanged: (Fruta? novaFruta) {
                setState(() {
                  _frutaSelecionada = novaFruta;
                  _atualizarValor();
                });
              },
              items: _frutas.map((Fruta fruta) {
                return DropdownMenuItem<Fruta>(
                  value: fruta,
                  child: Text(fruta.nome),
                );
              }).toList(),
              hint: Text('Selecione uma fruta'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _pesoController,
              decoration: InputDecoration(labelText: 'Quantidade (kg)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _atualizarValor(),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _valorController,
              decoration: InputDecoration(labelText: 'Valor Total'),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _cadastrarVenda,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Salvar Venda no Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
