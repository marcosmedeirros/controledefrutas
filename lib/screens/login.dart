import 'package:flutter/material.dart';
import 'package:controle_vendas_frutas/app-code/persistence/usuariodao.dart';
import 'package:controle_vendas_frutas/app-code/model/usuario.dart';
import 'package:controle_vendas_frutas/screens/home.dart';
import 'package:controle_vendas_frutas/screens/cadastrar_usuario.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String senha = _senhaController.text;

    Usuario? usuario = await UsuarioDao().fazerLogin(email, senha);//ve se o usuario existe no banco

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer o Login!')),
      );
    }
  }

  void _navigateToCadastrarUsuario() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastrarUsuario()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/usuario.png',
              height: 120,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: _login,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _navigateToCadastrarUsuario,
              child: Text(
                'Cadastre-se aqui!',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
