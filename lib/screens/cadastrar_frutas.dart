import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';

class AdicionarFrutaScreen extends StatefulWidget {
  @override
  _AdicionarFrutaScreenState createState() => _AdicionarFrutaScreenState();
}

class _AdicionarFrutaScreenState extends State<AdicionarFrutaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  Future<void> _adicionarFruta() async {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text;
      double preco = double.parse(_precoController.text);

      Fruta novaFruta = Fruta(nome: nome, preco: preco);
      await FrutaDao().adicionar(novaFruta);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fruta adicionada com sucesso!')));
      _nomeController.clear();
      _precoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Fruta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da fruta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço da fruta';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarFruta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Adicionar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
