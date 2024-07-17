
class Usuario {
  int? idUsuario;
  String nome;
  String email;
  String senha;

  Usuario({
    this.idUsuario,
    required this.nome,
    required this.email,
    required this.senha,
  });


  Map<String, dynamic> toMap() {
    return {
      //'idUsuario': idUsuario,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }



}