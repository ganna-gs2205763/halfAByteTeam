import 'package:accelaid/models/student.dart';
import 'package:accelaid/models/teacher.dart';
import 'package:accelaid/providers/repo_provider.dart';
import 'package:accelaid/providers/user_provider.dart';
import 'package:accelaid/repository/student_repo.dart';
import 'package:accelaid/repository/teacher_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherProvider extends AsyncNotifier<List<Teacher>> {
  late final TeacherRepo teacherRepo;
  late final User? teacher;
  @override
  build() async {
    teacherRepo = await ref.watch(teacherRepoProvider.future);
    teacher = await ref.read(userNotifierProvider.notifier).getCurrentUser();

    teacherRepo.observeTeacherss().listen((teacher) {
      state = AsyncValue.data(teacher);
    }).onError((e) {
      print('Error building teachers provider: $e');
    });

    return [];
  }

  Future<Teacher?> getTeacherSignedIn() async {
    return await teacherRepo.getTeacherByEmail(teacher!.email!);
  }
}

final teacherNotifierProvider =
    AsyncNotifierProvider<TeacherProvider, List<Teacher>>(
        () => TeacherProvider());
