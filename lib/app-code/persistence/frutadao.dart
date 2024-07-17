import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/fruta.dart';

class FrutaDao {
  late FirebaseFirestore db;
  FrutaDao() {
    _start();
  }

  void _start() {
    db = FirebaseFirestore.instance;
  }

  static const String _tableName = 'frutas';
  static const String _colIdFruta = 'idFruta';
  static const String _colNome = 'nome';
  static const String _colPreco = 'preco';


  String sqlTableFrutas = 'CREATE TABLE $_tableName('
      '$_colIdFruta INTEGER PRIMARY KEY,'
      '$_colNome TEXT,'
      '$_colPreco REAL'
      ')';

  Future<void> adicionar(Fruta fruta) async {
    try {
      await db.collection('frutas').add(fruta.toJson());
    } catch (e) {
      print('Erro ao adicionar fruta: $e');
    }
  }

  Future<void> deletar(String id) async {
    try {
      await db.collection('frutas').doc(id).delete();
    } catch (e) {
      print('Erro ao deletar fruta: $e');
    }
  }

  Future<List<Fruta>> getFrutas() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('frutas').get();
      return querySnapshot.docs.map((doc) {
        return Fruta.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
      }).toList();
    } catch (e) {
      print('Erro ao obter frutas: $e');
      return [];
    }
  }

  Future<bool> atualizar(Fruta fruta) async {
    try {
      await db.collection('frutas').doc(fruta.id).update(fruta.toJson());
      return true;
    } catch (e) {
      print('Erro ao atualizar fruta: $e');
      return false;
    }
  }
}
