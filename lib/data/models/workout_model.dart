import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  final int day;
  final int dayOfWeek;
  final int duration;
  final DateTime entryTime;
  final DateTime exitTime;
  final int month;
  final String userId;
  final Map<String, bool> workoutTags;
  final String workoutType;
  final int year;

  WorkoutModel({
    required this.day,
    required this.dayOfWeek,
    required this.duration,
    required this.entryTime,
    required this.exitTime,
    required this.month,
    required this.userId,
    required this.workoutTags,
    required this.workoutType,
    required this.year,
  });

  factory WorkoutModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;

    return WorkoutModel(
      day: data['day'] ?? 0,
      dayOfWeek: data['dayOfWeek'] ?? 0,
      duration: data['duration'] ?? 0,
      entryTime: (data['entryTime'] as Timestamp).toDate(),
      exitTime: (data['exitTime'] as Timestamp).toDate(),
      month: data['month'] ?? 0,
      userId: data['userId'] ?? '',
      workoutTags: Map<String, bool>.from(data['workoutTags'] ?? {}),
      workoutType: data['workoutType'] ?? '',
      year: data['year'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'day': day,
      'dayOfWeek': dayOfWeek,
      'duration': duration,
      'entryTime': Timestamp.fromDate(entryTime),
      'exitTime': Timestamp.fromDate(exitTime),
      'month': month,
      'userId': userId,
      'workoutTags': workoutTags,
      'workoutType': workoutType,
      'year': year,
    };
  }
}
