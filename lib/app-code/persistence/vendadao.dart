import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_vendas_frutas/app-code/model/venda.dart';

class VendaDao {
  late FirebaseFirestore db;
  VendaDao() {
    _start();
  }

  void _start() {
    db = FirebaseFirestore.instance;
  }

  static const String _tableName = 'vendas';
  static const String _colIdVenda = 'idVenda';
  static const String _colCliente = 'cliente';
  static const String _colFruta = 'fruta';
  static const String _colPeso = 'peso';
  static const String _colValor = 'valor';
  static const String _colData = 'data';

  String sqlTableVendas = 'CREATE TABLE $_tableName('
      '$_colIdVenda INTEGER PRIMARY KEY,'
      '$_colCliente TEXT,'
      '$_colFruta TEXT,'
      '$_colPeso REAL,'
      '$_colValor REAL,'
      '$_colData TEXT'
      ')';

  Future<void> adicionar(Venda venda) async {
    try {
      await db.collection('vendas').add(venda.toJson());
    } catch (e) {
      print('Erro ao adicionar venda: $e');
    }
  }

  Future<void> deletar(String idVenda) async {
    try {
      await db.collection('vendas').doc(idVenda).delete();
    } catch (e) {
      print('Erro ao deletar venda: $e');
    }
  }

  Future<List<Venda>> getVendas() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('vendas').get();
      return querySnapshot.docs.map((doc) {
        return Venda.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
      }).toList();
    } catch (e) {
      print('Erro ao obter vendas: $e');
      return [];
    }
  }

  Future<bool> atualizar(Venda venda) async {
    try {
      await db.collection('vendas').doc(venda.id).update(venda.toJson());
      return true;
    } catch (e) {
      print('Erro ao atualizar venda: $e');
      return false;
    }
  }

  Future<int> getNumeroVendas() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('vendas').get();
      return querySnapshot.size;
    } catch (e) {
      print('Erro ao obter número de vendas: $e');
      return 0;
    }
  }

  Future<double> getSomaPreco() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('vendas').get();
      double soma = querySnapshot.docs.fold(0, (previousValue, doc) {
        return previousValue + (doc['valor'] ?? 0.0);
      });
      return soma;
    } catch (e) {
      print('Erro ao calcular soma de preços: $e');
      return 0.0;
    }
  }

  Future<List<String>> getFrutasVendidas() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('vendas')
          .orderBy('valor', descending: true)
          .limit(4)
          .get();
      List<String> ultimasVendas = querySnapshot.docs.map((doc) {
        return '${doc['fruta']}: R\$${doc['valor']}';
      }).toList();
      return ultimasVendas;
    } catch (e) {
      print('Erro ao obter últimas vendas: $e');
      return [];
    }
  }
}
