import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_stats_app/data/models/workout_model.dart';
import 'package:snow_stats_app/domain/entities/workout.dart';
import 'package:snow_stats_app/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'gymUsageHistoryMock';

  WorkoutRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Workout>> getWorkoutsByUserId(String userId) async {
    try {
      // Using the existing index: userId Ascending, entryTime Descending, __name__ Descending
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('entryTime', descending: true)
          .get();

      return _convertQuerySnapshotToWorkouts(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get workouts: $e');
    }
  }

  @override
  Future<List<Workout>> getWorkoutsByTimePeriod(
      DateTime startDate, DateTime endDate) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('entryTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('entryTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('entryTime', descending: true)
          .get();

      return _convertQuerySnapshotToWorkouts(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get workouts by time period: $e');
    }
  }

  @override
  Future<List<Workout>> getWorkoutsByUserIdAndTimePeriod(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      // Using the existing index: userId Ascending, entryTime Descending, __name__ Descending
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('entryTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('entryTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('entryTime', descending: true)
          .get();

      return _convertQuerySnapshotToWorkouts(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get workouts by userId and time period: $e');
    }
  }

  @override
  Future<List<Workout>> getAllWorkouts({int? limit}) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_collectionName)
          .orderBy('entryTime', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      return _convertQuerySnapshotToWorkouts(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get all workouts: $e');
    }
  }

  // Helper method to convert QuerySnapshot to List<Workout>
  List<Workout> _convertQuerySnapshotToWorkouts(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final workoutModel = WorkoutModel.fromFirestore(doc);
      return Workout(
        day: workoutModel.day,
        dayOfWeek: workoutModel.dayOfWeek,
        duration: workoutModel.duration,
        entryTime: workoutModel.entryTime,
        exitTime: workoutModel.exitTime,
        month: workoutModel.month,
        userId: workoutModel.userId,
        workoutTags: workoutModel.workoutTags,
        workoutType: workoutModel.workoutType,
        year: workoutModel.year,
      );
    }).toList();
  }
}
