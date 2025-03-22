import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_stats_app/data/models/gym_class_model.dart';
import 'package:snow_stats_app/domain/entities/gym_class.dart';
import 'package:snow_stats_app/domain/repositories/gym_class_repository.dart';

class GymClassRepositoryImpl implements GymClassRepository {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'classes';

  GymClassRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<GymClass>> getAllClasses() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('classTime', descending: false)
          .get();

      return _convertQuerySnapshotToGymClasses(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get all classes: $e');
    }
  }

  @override
  Future<GymClass?> getClassById(String classId) async {
    try {
      final documentSnapshot =
          await _firestore.collection(_collectionName).doc(classId).get();

      if (!documentSnapshot.exists) {
        return null;
      }

      final gymClassModel = GymClassModel.fromFirestore(documentSnapshot);
      return gymClassModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get class by ID: $e');
    }
  }

  @override
  Future<List<GymClass>> getClassesByTag(String tag) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('tags.$tag', isEqualTo: true)
          .orderBy('classTime', descending: false)
          .get();

      return _convertQuerySnapshotToGymClasses(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get classes by tag: $e');
    }
  }

  @override
  Future<List<GymClass>> getClassesByDate(DateTime date) async {
    try {
      // Create start and end timestamps for the given date
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('classTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('classTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('classTime', descending: false)
          .get();

      return _convertQuerySnapshotToGymClasses(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get classes by date: $e');
    }
  }

  @override
  Future<String> createClass(GymClass gymClass) async {
    try {
      // Convert entity to model
      final gymClassModel = GymClassModel.fromEntity(gymClass);

      // Create a new document with auto-generated ID
      final docRef = _firestore.collection(_collectionName).doc();

      // Store the data
      await docRef.set(gymClassModel.toFirestore());

      // Return the generated document ID
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create class: $e');
    }
  }

  @override
  Future<void> updateClass(GymClass gymClass) async {
    try {
      // Convert entity to model
      final gymClassModel = GymClassModel.fromEntity(gymClass);

      // Update the document
      await _firestore
          .collection(_collectionName)
          .doc(gymClass.classId)
          .update(gymClassModel.toFirestore());
    } catch (e) {
      throw Exception('Failed to update class: $e');
    }
  }

  @override
  Future<void> deleteClass(String classId) async {
    try {
      await _firestore.collection(_collectionName).doc(classId).delete();
    } catch (e) {
      throw Exception('Failed to delete class: $e');
    }
  }

  // Helper method to convert QuerySnapshot to List<GymClass>
  List<GymClass> _convertQuerySnapshotToGymClasses(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final gymClassModel = GymClassModel.fromFirestore(doc);
      return gymClassModel.toEntity();
    }).toList();
  }
}
