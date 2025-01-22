import 'package:accelaid/models/color_const.dart';
import 'package:accelaid/models/student.dart';
import 'package:accelaid/providers/grade_student_search_provider.dart';
import 'package:accelaid/providers/student_provider.dart';
import 'package:accelaid/routes/app_router.dart';
import 'package:accelaid/screens/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AllStudentsScreen extends ConsumerStatefulWidget {
  const AllStudentsScreen({super.key});

  @override
  ConsumerState<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends ConsumerState<AllStudentsScreen> {
  @override
  Widget build(BuildContext context) {
    final studentProvider = ref.watch(studentNotifierProvider);
    final studentNotifier = ref.read(studentNotifierProvider.notifier);
    final searchProvider = ref.watch(gradeStudentSearchNotifierProvider);
    final searchNotifier =
        ref.read(gradeStudentSearchNotifierProvider.notifier);

    return studentProvider.when(
        data: ((customers) {
          final isSearchEmpty = searchProvider.isEmpty;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: searchProvider,
                  decoration: InputDecoration(
                      prefixIconColor: darkred,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      hintText: "Search",
                      labelText: "Search Student"),
                  onChanged: (query) {
                    searchNotifier.setSearch(query);
                  },
                ),
                Expanded(
                  child: (isSearchEmpty)
                      ? StreamBuilder<List<Student>>(
                          stream: studentNotifier.getAllStudentsByTeacher(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final filteredStudents = snapshot.data ?? [];
                            return studentCardList(filteredStudents);
                          },
                        )
                      : StreamBuilder<List<Student>>(
                          stream: studentNotifier.searchStudents(
                              '0', searchProvider),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final filteredStudents = snapshot.data ?? [];
                            return studentCardList(filteredStudents);
                          },
                        ),
                ),
              ],
            ),
          );
        }),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error: ${error.toString()}')));
  }

  Widget studentCardList(List<Student> filteredStudents) {
    return ListView.builder(
        itemCount: filteredStudents.length,
        itemBuilder: (BuildContext context, int index) {
          final student = filteredStudents[index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(AppRouter.studentProfile.name,
                  pathParameters: {'stId': student.stId});
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        '${student.firstName} ${student.lastName}',
                        style: dataTextStyle(c: darkblue),
                      ),
                      const Spacer(),
                      Text('ID# ', style: labelTextStyle(c: lightblue)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(50, 116, 142, 173),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          student.stId,
                          style: labelTextStyle(c: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.nationality,
                          style: labelTextStyle(
                              c: grey, w: FontWeight.normal, f: 18)),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text("GRADE  ${student.gradeLevel}",
                            style: labelTextStyle(c: lightblue, f: 16)),
                      ),
                      Text('PROGRESS', style: labelTextStyle(c: darkblue)),
                      Row(
                        children: [
                          SizedBox(
                            width: 285,
                            height: 12,
                            child: ProgressBar(progress: student.progress),
                          ),
                          Text(
                              '%${(student.progress * 100).toStringAsFixed(0)}',
                              style: labelTextStyle(c: darkblue))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
