import 'package:accelaid/models/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherRepo {
  final CollectionReference teacherRef;

  TeacherRepo({required this.teacherRef});

  /// observe all Students
  Stream<List<Teacher>> observeTeacherss() {
    return teacherRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Teacher.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  /// Get a student by ID
  Future<Teacher> getTeacherByEmail(String email) async {
    final snapshot = await teacherRef.doc(email).get();
    return Teacher.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
