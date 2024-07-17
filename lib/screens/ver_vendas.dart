import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/model/venda.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';
import '../app-code/model/fruta.dart';

class VerVendas extends StatefulWidget {
  @override
  _VerVendasState createState() => _VerVendasState();
}

class _VerVendasState extends State<VerVendas> {
  Future<List<Venda>>? _vendasFuture;
  final VendaDao _vendaDao = VendaDao();

  @override
  void initState() {
    super.initState();
    _carregarVendas();
  }

  void _carregarVendas() {
    setState(() {
      _vendasFuture = _vendaDao.getVendas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendas Realizadas'),
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
                Navigator.pushReplacementNamed(context, '/cadastrar_vendas');
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Ver Vendas'),
              onTap: () {
                Navigator.pop(context);
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
      body: FutureBuilder<List<Venda>>(
        future: _vendasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar vendas.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma venda encontrada.'));
          } else {
            List<Venda> vendas = snapshot.data!;
            return ListView.builder(
              itemCount: vendas.length,
              itemBuilder: (context, index) {
                final venda = vendas[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    title: Text(
                      '${venda.cliente} - ${venda.fruta}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Peso: ${venda.peso.toString()} - Valor: R\$ ${venda.valor.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => EditarVendaDialog(
                                venda: venda,
                                onUpdate: _carregarVendas,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _vendaDao.deletar(venda.id as String);
                            _carregarVendas();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EditarVendaDialog extends StatefulWidget {
  final Venda venda;
  final VoidCallback onUpdate;

  EditarVendaDialog({required this.venda, required this.onUpdate});

  @override
  _EditarVendaDialogState createState() => _EditarVendaDialogState();
}

class _EditarVendaDialogState extends State<EditarVendaDialog> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _frutaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clienteController.text = widget.venda.cliente;
    _frutaController.text = widget.venda.fruta;
    _pesoController.text = widget.venda.peso.toString();
    _valorController.text = widget.venda.valor.toString();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _frutaController.dispose();
    _pesoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Venda'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _clienteController,
              decoration: InputDecoration(labelText: 'Cliente'),
            ),
            TextField(
              controller: _frutaController,
              decoration: InputDecoration(labelText: 'Fruta'),
            ),
            TextField(
              controller: _pesoController,
              decoration: InputDecoration(labelText: 'Peso'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final String cliente = _clienteController.text.trim();
            final String fruta = _frutaController.text.trim();
            final double peso = double.parse(_pesoController.text.trim());
            final double valor = double.parse(_valorController.text.trim());

            final Venda vendaAtualizada = Venda(
              id: widget.venda.id,
              cliente: cliente,
              fruta: fruta,
              peso: peso,
              valor: valor,
              data: widget.venda.data,
            );

            bool sucesso = await VendaDao().atualizar(vendaAtualizada);

            if (sucesso) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Venda atualizada com sucesso')),
              );
              widget.onUpdate();
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Falha ao atualizar a venda')),
              );
            }
          },
          child: Text('Salvar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
