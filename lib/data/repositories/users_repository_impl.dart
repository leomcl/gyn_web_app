import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_stats_app/domain/entities/user.dart';
import 'package:snow_stats_app/domain/repositories/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UsersRepositoryImpl implements UsersRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  UsersRepositoryImpl({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<List<User>> getAllUsers() async {
    try {
      // Check if user is authenticated
      if (_auth.currentUser == null) {
        return [];
      }

      final querySnapshot = await _firestore.collection('users').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          uid: doc.id, // Use document ID as the uid
          email: data['email'] ?? '',
          role: data['role'],
          membershipStatus: data['membershipStatus'] ?? false,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<User?> getUserById(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      return User(
        uid: docSnapshot.id,
        email: data['email'] ?? '',
        role: data['role'],
        membershipStatus: data['membershipStatus'] ?? false,
      );
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}
