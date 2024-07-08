import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/model/venda.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/persistence/vendadao.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';

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
        backgroundColor: Colors.green,
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
                    subtitle: Text('Peso: ${venda.peso} kg\nValor: R\$ ${venda.valor}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => EditarVendaPopup(
                                venda: venda,
                                onUpdate: _carregarVendas,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await VendaDao().deletar(venda.idVenda);
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

class EditarVendaPopup extends StatefulWidget {
  final Venda venda;
  final VoidCallback onUpdate;

  EditarVendaPopup({required this.venda, required this.onUpdate});

  @override
  _EditarVendaPopupState createState() => _EditarVendaPopupState();
}

class _EditarVendaPopupState extends State<EditarVendaPopup> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _frutaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  Fruta? _frutaSelecionada;

  @override
  void initState() {
    super.initState();
    _clienteController.text = widget.venda.cliente;
    _frutaController.text = widget.venda.fruta;
    _pesoController.text = widget.venda.peso.toString();
    _valorController.text = widget.venda.valor.toString();
    FrutaDao().getFrutas().then((frutas) {
      setState(() {
        _frutaSelecionada = frutas.firstWhere((fruta) => fruta.nome == widget.venda.fruta);
      });
    });
    _pesoController.addListener(_atualizarValor);
  }

  void _atualizarValor() {
    if (_frutaSelecionada != null && _pesoController.text.isNotEmpty) {
      double quantidade = double.tryParse(_pesoController.text) ?? 0.0;
      setState(() {
        _valorController.text = (quantidade * _frutaSelecionada!.preco).toStringAsFixed(2);
      });
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _frutaController.dispose();
    _pesoController.dispose();
    _valorController.dispose();
    _pesoController.removeListener(_atualizarValor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Venda'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _clienteController,
            decoration: InputDecoration(labelText: 'Cliente'),
          ),
          TextField(
            controller: _frutaController,
            decoration: InputDecoration(labelText: 'Fruta'),
            enabled: false,
          ),
          TextField(
            controller: _pesoController,
            decoration: InputDecoration(labelText: 'Peso (kg)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _valorController,
            decoration: InputDecoration(labelText: 'Valor (R\$)'),
            keyboardType: TextInputType.number,
            enabled: false,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final String cliente = _clienteController.text.trim();
            final String fruta = _frutaController.text.trim();
            final double peso = double.parse(_pesoController.text.trim());
            final double valor = double.parse(_valorController.text.trim());

            final Venda vendaAtualizada = Venda(
              idVenda: widget.venda.idVenda,
              cliente: cliente,
              fruta: fruta,
              peso: peso,
              valor: valor,
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Salvar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
