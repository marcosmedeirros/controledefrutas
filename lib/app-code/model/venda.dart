




class Venda {
  final int? idVenda;
  final String cliente;
  final String fruta;
  final double peso;
  final double valor;

  Venda({
    this.idVenda,
    required this.cliente,
    required this.fruta,
    required this.peso,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      //'id': idVenda,
      'cliente': cliente,
      'fruta': fruta,
      'peso': peso,
      'valor': valor,
    };
  }

}
