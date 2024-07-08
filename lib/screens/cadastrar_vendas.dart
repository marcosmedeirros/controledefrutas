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
        _valorController.text = (quantidade * _frutaSelecionada!.preco).toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.green,
          child: Text(
            'Adicionar Venda',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _clienteController,
                decoration: InputDecoration(labelText: 'Cliente'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Fruta',
                  hintText: 'Selecione uma fruta',
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Fruta>(
                    isExpanded: true,
                    value: _frutaSelecionada,
                    onChanged: (Fruta? novaFruta) {
                      setState(() {
                        _frutaSelecionada = novaFruta!;
                        _atualizarValor();
                      });
                    },
                    items: _frutas.map((Fruta fruta) {
                      return DropdownMenuItem<Fruta>(
                        value: fruta,
                        child: Text(fruta.nome),
                      );
                    }).toList(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    hint: Text(
                      'Selecione uma fruta',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _pesoController,
                decoration: InputDecoration(labelText: 'Quantidade (kg)'),
                keyboardType: TextInputType.number,
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
                onPressed: () {
                  if (_frutaSelecionada != null) {
                    Venda venda = Venda(
                      idVenda: 0,
                      cliente: _clienteController.text,
                      fruta: _frutaSelecionada!.nome,
                      peso: double.parse(_pesoController.text),
                      valor: double.parse(_valorController.text),
                    );

                    VendaDao().adicionar(venda).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Venda cadastrada com sucesso!')),
                      );
                      _clienteController.clear();
                      _pesoController.clear();
                      _valorController.clear();
                      setState(() {
                        _frutaSelecionada = null;
                      });
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar venda: $error')),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selecione uma fruta')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Salvar Venda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
