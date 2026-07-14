import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/trip_model.dart';

class TripService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveTrip(TripModel trip) async {
    final uid = _uid;
    if (uid == null) return;
    await _db.collection('trips').add({
      ...trip.toMap(),
      'userId': uid,
    });
  }

  // CHANGED: added delete support
  Future<void> deleteTrip(String tripId) async {
    await _db.collection('trips').doc(tripId).delete();
  }

  Stream<List<TripModel>> get tripsStream {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('trips')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs.map((d) => TripModel.fromMap(d.id, d.data())).toList());
  }
}
