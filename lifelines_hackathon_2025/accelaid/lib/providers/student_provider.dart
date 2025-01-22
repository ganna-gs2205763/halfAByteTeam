import 'package:accelaid/models/student.dart';
import 'package:accelaid/providers/repo_provider.dart';
import 'package:accelaid/providers/user_provider.dart';
import 'package:accelaid/repository/student_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentProvider extends AsyncNotifier<List<Student>> {
  late final StudentRepo studentRepo;
  late final User? teacher;
  @override
  build() async {
    studentRepo = await ref.watch(studentRepoProvider.future);
    teacher = await ref.read(userNotifierProvider.notifier).getCurrentUser();

    studentRepo.observeStudents().listen((student) {
      state = AsyncValue.data(student);
    }).onError((e) {
      print('Error building students provider: $e');
    });

    return [];
  }

  /// Get a student by ID
  Student? getStudentById(String id) {
    return state.value?.firstWhere((s) => s.stId == id);
  }

  /// Add  a student
  Future<void> addStudent(Student student) async {
    await studentRepo.addStudent(student);
  }

  /// update a student
  Future<void> updateStudent(Student student) async{
    await studentRepo.updateStudent(student);
  }

  /// Delete a student
  Future<void> deleteStudent(Student student) async {
    await studentRepo.deleteStudent(student);
  }

  /// Search students by first name or ID
  Stream<List<Student>> searchStudents(String grade, String q) {
    return studentRepo.searchStudents(grade, teacher!.email ?? '', q);
  }
Stream<List<Student>> getAllStudentsByTeacher() {
    return studentRepo.getAllStudentsByTeacher(teacher!.email ?? '');
  }


  /// Retrive students in the same grade
  Stream<List<Student>> getGradeStudents(String grade) {
    return studentRepo.getGradeStudents(grade, teacher!.email ?? '');
  }
}

final studentNotifierProvider =
    AsyncNotifierProvider<StudentProvider, List<Student>>(
        () => StudentProvider());
