import 'package:database_repository/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template poluente_repository}
/// Repository whitch manages poluentes.
/// {@endtemplate}
class PoluenteRepository {
  /// {@macro Poluente_repository}
  PoluenteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<List<Poluente>> listAll({required String userId}) {
    try {
      return _firebaseFirestore
          .collection('poluentes')
          .doc(userId)
          .collection('poluente')
          .orderBy('name')
          .snapshots()
          .map((result) {
        final List<Poluente> poluentes = <Poluente>[];
        result.docs.forEach((doc) {
          final data = doc.data();
          var date;
          try {
            date = (data['date'] as Timestamp).toDate();
          } catch (exception) {}
          poluentes.add(
            Poluente(
                id: doc.id,
                name: data['name'],
                size: data['size'],
                solution: data['solution'],
                date: date),
          );
        });
        return poluentes;
      });
    } catch (excption) {
      rethrow;
    }
  }

  Future<Poluente> add({required String userId, required Poluente poluente}) {
    try {
      var date;
      try {
        date = Timestamp.fromDate(poluente.date!);
      } catch (exception) {}
      return _firebaseFirestore
          .collection('poluentes')
          .doc(userId)
          .collection('poluente')
          .add({
        'name': poluente.name,
        'size': poluente.size,
        'solution': poluente.solution,
        'date': date,
      }).then((result) {
        return Poluente(
            id: result.id,
            name: poluente.name,
            size: poluente.size,
            solution: poluente.solution,
            date: poluente.date);
      });
    } catch (excption) {
      rethrow;
    }
  }

  Future<void> update({required String userId, required Poluente poluente}) {
    try {
      var date;
      try {
        date = Timestamp.fromDate(poluente.date!);
      } catch (exception) {}
      return _firebaseFirestore
          .collection('poluentes')
          .doc(userId)
          .collection('poluente')
          .doc(poluente.id)
          .update({
        'name': poluente.name,
        'size': poluente.size,
        'solution': poluente.solution,
        'date': date,
      });
    } catch (excption) {
      rethrow;
    }
  }

  Future<void> delete({required String userId, required Poluente poluente}) {
    try {
      return _firebaseFirestore
          .collection('poluentes')
          .doc(userId)
          .collection('poluente')
          .doc(poluente.id)
          .delete();
    } catch (excption) {
      rethrow;
    }
  }
}
