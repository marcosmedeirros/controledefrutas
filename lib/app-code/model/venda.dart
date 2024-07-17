import 'package:cloud_firestore/cloud_firestore.dart';

class Venda {
  String? id;
  final String cliente;
  final String fruta;
  final double peso;
  final double valor;
  final DateTime data;

  Venda({
    this.id,
    required this.cliente,
    required this.fruta,
    required this.peso,
    required this.valor,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'cliente': cliente,
      'fruta': fruta,
      'peso': peso,
      'valor': valor,
      'data': Timestamp.fromDate(data),
    };
  }

  factory Venda.fromJson(Map<String, dynamic> json, {String? id}) {
    return Venda(
      id: id,
      cliente: json['cliente'],
      fruta: json['fruta'],
      peso: json['peso'],
      valor: json['valor'],
      data: (json['data'] as Timestamp).toDate(),
    );
  }
}
