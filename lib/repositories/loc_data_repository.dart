import 'package:cloud_firestore/cloud_firestore.dart';

class LocDataRepository {
  final CollectionReference toiletsCollection = FirebaseFirestore
      .instance.collection('toilets');

  final CollectionReference dustbinsCollection = FirebaseFirestore
      .instance.collection('dustbins');


  Stream<QuerySnapshot> toiletsGetStream() {
    return toiletsCollection.snapshots();
  }

  Stream<QuerySnapshot> dustbinsGetStream() {
    return dustbinsCollection.snapshots();
  }

}