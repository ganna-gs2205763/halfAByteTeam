import 'package:accelaid/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRepo {
  final CollectionReference studentRef;

  StudentRepo({required this.studentRef});

  /// observe all Students
  Stream<List<Student>> observeStudents() {
    return studentRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Student.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  /// Get a student by ID
  Future<Student> getStudentById(String id) async {
    final snapshot = await studentRef.doc(id).get();
    return Student.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  /// Add a student
  Future<void> addStudent(Student student) async {
    await studentRef.doc(student.stId).set(student.toMap());
  }

  /// update a student
  Future<void> updateStudent(Student st) async {
      try {
        await studentRef.doc(st.stId).update(st.toMap());
      } catch (e) {
        print("Error updating student: $e");
        rethrow;
      }
    }

  /// Delete a student
  Future<void> deleteStudent(Student student) async {
    await studentRef.doc(student.stId).delete();
  }

  /// get all teacher's students
  Stream<List<Student>> getAllStudentsByTeacher(String teacherEmail) {
    final allStudents = studentRef
        .where("teacherEmail", isEqualTo: teacherEmail)
        .orderBy("gradeLevel", descending: false);

    return allStudents.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Student.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Search Students
  Stream<List<Student>> searchStudents(
      String grade, String teacherEmail, String q) {
    final query = q.toLowerCase();

    final filtered = studentRef.where(Filter.and(
      (grade != '0')
          ? Filter("gradeLevel", isEqualTo: grade)
          : Filter("gradeLevel", isGreaterThan: '0'),
      Filter("teacherEmail", isEqualTo: teacherEmail),
      Filter.or(
        Filter.and(
          Filter("firstNameLower", isGreaterThanOrEqualTo: query),
          Filter("firstNameLower", isLessThan: "$query\uf8ff"),
        ),
        Filter.and(
          Filter("lastNameLower", isGreaterThanOrEqualTo: query),
          Filter("lastNameLower", isLessThan: "$query\uf8ff"),
        ),
      ),
    ));

    return filtered.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Student.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Get students in the same grade
  Stream<List<Student>> getGradeStudents(String grade, String teacherEmail) {
    final filtered = studentRef.where(Filter.and(
      Filter("gradeLevel", isEqualTo: grade),
      Filter("teacherEmail", isEqualTo: teacherEmail),
    ));
    return filtered.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Student.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
