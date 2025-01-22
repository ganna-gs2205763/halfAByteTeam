import 'package:accelaid/models/color_const.dart';
import 'package:accelaid/providers/title_provider.dart';
import 'package:accelaid/providers/user_provider.dart';
import 'package:accelaid/routes/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends ConsumerStatefulWidget {
  final Widget? body;
  const ShellScreen({super.key, this.body});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  @override
  Widget build(BuildContext context) {
    final titleProvider = ref.watch(titleNotifierProvider);
    final titleNotifier = ref.read(titleNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleProvider,
          style: TextStyle(
            fontSize: 23,
            color: darkblue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              duration: const Duration(seconds: 5),
              curve: Curves.bounceInOut,
              decoration: BoxDecoration(
                color: darkblue,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_rounded, color: lightblue),
              title: Text('Home', style: TextStyle(color: darkblue)),
              onTap: () {
                context.pop();
                titleNotifier.setTitle('AccelAid');
                context.goNamed(AppRouter.dashboard.name);
              },
            ),
            ListTile(
              leading: Icon(Icons.people_alt_outlined, color: lightblue),
              title: Text('All Students', style: TextStyle(color: darkblue)),
              onTap: () {
                context.pop();
                titleNotifier.setTitle('All Students');
                context.goNamed(AppRouter.allStudents.name);
              },
            ),
            ListTile(
              leading: Icon(Icons.people_alt, color: lightblue),
              title:
                  Text('Students by Grade', style: TextStyle(color: darkblue)),
              onTap: () {
                context.pop();
                titleNotifier.setTitle('Students by Grade');
                context.goNamed(AppRouter.gradelevels.name);
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined, color: lightblue),
              title: Text('Competency Exam', style: TextStyle(color: darkblue)),
              onTap: () {
                context.pop();
                titleNotifier.setTitle('Generate Competency Exam');
                context.goNamed(AppRouter.generateCompExam.name);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: lightblue),
              title: Text('Log Out', style: TextStyle(color: darkblue)),
              onTap: () {
                ref.read(userNotifierProvider.notifier).signOut();
                
                context.goNamed(AppRouter.login.name);
              },
            ),
          ],
        ),
      ),
      body: widget.body ?? const Center(child: Text('Body Content')),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget? _getFloatingActionButton() {
    final currentLocation =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    if (currentLocation == AppRouter.gradelevels.path) {
      return FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRouter.addStudent.name);
          print('FAB Pressed on Grade Levels Screen');
        },
        child: const Icon(Icons.add),
      );
    }

    return null;
  }
}
