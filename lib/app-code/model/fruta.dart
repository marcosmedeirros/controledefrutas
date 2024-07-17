
class Fruta {
  String? id;
  final String nome;
  final double preco;
  final String foto;

  Fruta({
    this.id,
    required this.nome,
    required this.preco,
    required this.foto
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'preco': preco,
      'foto': foto,
    };
  }

  factory Fruta.fromJson(Map<String, dynamic> json, {String? id}) {
    return Fruta(
      id: id,
      nome: json['nome'],
      preco: json['preco'],
      foto: json['foto'],
    );
  }
}
