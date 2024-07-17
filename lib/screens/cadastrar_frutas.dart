import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:controle_vendas_frutas/app-code/model/fruta.dart';
import 'package:controle_vendas_frutas/app-code/persistence/frutadao.dart';

class CadastrarFrutas extends StatefulWidget {
  @override
  _CadastrarFrutaState createState() => _CadastrarFrutaState();
}

class _CadastrarFrutaState extends State<CadastrarFrutas> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  File? _imagemSelecionada;
  late FrutaDao _frutaDao;

  @override
  void initState() {
    super.initState();
    _frutaDao = FrutaDao();
  }

  Future<void> _escolherImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imagemSelecionada = File(pickedFile.path);
      }
    });
  }

  //tava dando erro deixar essa função no frutadao
  Future<void> _cadastrarFruta() async {
    String nome = _nomeController.text.trim();
    double preco = double.tryParse(_precoController.text.trim()) ?? 0.0;
    String foto = _imagemSelecionada?.path ?? '';

    if (nome.isNotEmpty && preco > 0) {
      try {
        Fruta novaFruta = Fruta(nome: nome, preco: preco, foto: foto);
        await _frutaDao.adicionar(novaFruta);

        _nomeController.clear();
        _precoController.clear();
        setState(() {
          _imagemSelecionada = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fruta cadastrada com sucesso no Firebase!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar fruta no Firebase: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Fruta'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(//menu lateral
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
                Navigator.pushNamedAndRemoveUntil(
                  context, '/login',
                  ModalRoute.withName('/'),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 80.0),
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome da Fruta'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _precoController,
                    decoration: InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _escolherImagem,
                    child: Text('Escolher Imagem'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                      foregroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _cadastrarFruta,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Salvar Fruta no Firebase'),
                  ),
                ],
              ),
            ),
          ),
          if (_imagemSelecionada != null)
            Positioned(
              top: 16.0,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: FileImage(_imagemSelecionada!),
              ),
            ),
        ],
      ),
    );
  }
}
