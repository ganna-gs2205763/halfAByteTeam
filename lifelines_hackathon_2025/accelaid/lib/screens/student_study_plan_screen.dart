import 'package:accelaid/models/color_const.dart';
import 'package:accelaid/models/student.dart';
import 'package:accelaid/providers/student_provider.dart';
import 'package:accelaid/routes/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentStudyPlanScreen extends ConsumerStatefulWidget {
  final String stId;
  final String studyPlan;

  const StudentStudyPlanScreen({
    super.key,
    required this.stId,
    required this.studyPlan,
  });

  @override
  ConsumerState<StudentStudyPlanScreen> createState() =>
      _StudentStudyPlanViewState();
}

class _StudentStudyPlanViewState extends ConsumerState<StudentStudyPlanScreen> {
  @override
  Widget build(BuildContext context) {
    Student? student =
        ref.read(studentNotifierProvider.notifier).getStudentById(widget.stId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        title: Text(
          "Study Plan",
          style: TextStyle(
            fontSize: 23,
            color: darkblue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: (student!.hasStudyPlan)
            ? FilePageBody(
                widget.studyPlan,
                'Current Study Plan 2025',
                16,
                const Icon(
                  Icons.schedule,
                  color: Colors.blueAccent,
                  size: 30,
                ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Icon(
                    CupertinoIcons.doc_text,
                    size: 100,
                    color: lightblue,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Available Study Plan yet for ${student.firstName}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: darkblue,
                        elevation: 3,
                        fixedSize: const Size(345, 70),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      context.pushNamed(AppRouter.generateStudyPlan.name,
                          pathParameters: {'stId': student.stId});
                    },
                    child: const Text(
                      "Generate Study Plan",
                      style: TextStyle(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Tip: Generating a study plan using AI will be efficient!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
