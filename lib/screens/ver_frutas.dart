import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';
import 'dart:io';

class VerFrutas extends StatefulWidget {
  @override
  _VerFrutasState createState() => _VerFrutasState();
}

class _VerFrutasState extends State<VerFrutas> {
  Future<List<Fruta>>? _frutasFuture;

  @override
  void initState() {
    super.initState();
    _carregarFrutas();
  }

  void _carregarFrutas() {
    setState(() {
      _frutasFuture = FrutaDao().getFrutas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frutas Cadastradas'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(//Menu lateral
              decoration: const BoxDecoration(
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
                Navigator.pop(context);
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
                Navigator.pushReplacementNamed(context, '/ver_vendas');
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
      body: FutureBuilder<List<Fruta>>(
        future: _frutasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as frutas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma fruta encontrada'));
          } else {
            List<Fruta> frutas = snapshot.data!;
            return ListView.builder(
              itemCount: frutas.length,
              itemBuilder: (context, index) {
                final fruta = frutas[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    leading: fruta.foto.isNotEmpty
                        ? CircleAvatar(
                      radius: 30.0,
                      backgroundImage: FileImage(File(fruta.foto)),
                    )
                        : CircleAvatar(
                      radius: 30.0,
                      child: Icon(Icons.image, size: 30.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    title: Text(fruta.nome),
                    subtitle: Text('Preço: R\$ ${fruta.preco.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => EditarFrutaPopup(
                                fruta: fruta,
                                onUpdate: _carregarFrutas,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await FrutaDao().deletar(fruta.id as String);
                            _carregarFrutas();
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

class EditarFrutaPopup extends StatefulWidget {//o popup chamado pra editar
  final Fruta fruta;
  final VoidCallback onUpdate;

  EditarFrutaPopup({required this.fruta, required this.onUpdate});

  @override
  _EditarFrutaPopupState createState() => _EditarFrutaPopupState();
}

class _EditarFrutaPopupState extends State<EditarFrutaPopup> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.fruta.nome;
    _precoController.text = widget.fruta.preco.toString();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Fruta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: _precoController,
            decoration: InputDecoration(labelText: 'Preço'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final String nome = _nomeController.text.trim();
            final double preco = double.parse(_precoController.text.trim());
            final Fruta frutaAtualizada = Fruta(
              id: widget.fruta.id,
              nome: nome,
              preco: preco,
              foto: widget.fruta.foto,
            );
            bool sucesso = await FrutaDao().atualizar(frutaAtualizada);//chama a dao pra atualizar
            if (sucesso) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fruta atualizada com sucesso')),
              );
              widget.onUpdate();
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Falha ao atualizar a fruta')),
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
