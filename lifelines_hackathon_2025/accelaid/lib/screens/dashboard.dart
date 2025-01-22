import 'package:accelaid/models/color_const.dart';
import 'package:accelaid/models/teacher.dart';
import 'package:accelaid/providers/teacher_provider.dart';
import 'package:accelaid/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  late Future<User?> teacherFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = ref.watch(teacherNotifierProvider);
    return FutureBuilder<Teacher?>(
      future: ref.read(teacherNotifierProvider.notifier).getTeacherSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          Teacher? teacher = snapshot.data;
          return Stack(children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/layout/dash_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(70.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(
                          'assets/images/layout/accelaid_icon.png')),
                  Padding(
                      padding: const EdgeInsets.only(left: 9.0, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Hello, ',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w300)),
                              Text('${teacher!.firstName}!',
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text('Welcome to AccelAid.',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: grey,
                                  letterSpacing: 0.5)),
                        ],
                      )),
                ],
              ),
            )
          ]);
        } else {
          return const Center(child: Text('No teacher found.'));
        }
      },
    );
  }
}
