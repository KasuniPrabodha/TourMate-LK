import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/destination_model.dart';

// Stores saved places per-user in Firestore, collection 'savedPlaces'.
// Doc id = "<uid>_<placeName>" so adding the same place twice just overwrites,
// and removing is a simple doc delete.
class SavedPlacesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> addPlace(DestinationModel place) async {
    final uid = _uid;
    if (uid == null) return;
    await _db.collection('savedPlaces').doc('${uid}_${place.place}').set({
      ...place.toMap(),
      'userId': uid,
    });
  }

  Future<void> removePlace(String placeName) async {
    final uid = _uid;
    if (uid == null) return;
    await _db.collection('savedPlaces').doc('${uid}_$placeName').delete();
  }

  Stream<List<DestinationModel>> get savedPlacesStream {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('savedPlaces')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs.map((d) => DestinationModel.fromMap(d.data())).toList());
  }
}