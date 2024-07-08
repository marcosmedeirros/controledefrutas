



class Fruta {
  final int? id;
  final String nome;
  final double preco;

  Fruta({
    this.id,
    required this.nome,
    required this.preco
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
    };
  }
}
