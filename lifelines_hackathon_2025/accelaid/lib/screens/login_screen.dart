import 'package:accelaid/models/color_const.dart';
import 'package:accelaid/providers/user_provider.dart';
import 'package:accelaid/routes/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

var errorController = TextEditingController(text: '');
String email = '', password = '';

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void dispose() {
    email = '';
    password = '';
    errorController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: AlignmentDirectional.centerStart, children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/layout/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            bottom: 6,
            right: 130,
            child: Text(
              'AccelAid.',
              style: TextStyle(
                  fontSize: 30,
                  color: lightblue,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0),
            )),
        Positioned(
          right: 60,
          top: 270,
          child: SizedBox(
            width: 290,
            height: 300,
            child: Card(
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 15.0, right: 20, left: 20, top: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMAIL:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: darkblue,
                        letterSpacing: 1.1,
                      ),
                    ),
                    TextField(
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 56, 56, 56)),
                        decoration: const InputDecoration(
                          labelText: (' abc@gmail.com'),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          fillColor: Color.fromARGB(151, 151, 151, 151),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                        ),
                        onChanged: (value) => email = value),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'PASSWORD:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: darkblue,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    TextField(
                        onChanged: (value) => password = value,
                        obscureText: true,
                        style: TextStyle(fontSize: 15, color: grey),
                        decoration: InputDecoration(
                          labelText: (' •••••••••'),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: const TextStyle(fontSize: 15),
                          fillColor: grey,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                        )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: darkred,
                              elevation: 3,
                              fixedSize: const Size(90, 40),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            if (email.trim().isEmpty ||
                                password.trim().isEmpty) {
                              snackbarError(
                                  context, 'Fill all Fields.', darkred);
                            } else {
                              User? user = await ref
                                  .read(userNotifierProvider.notifier)
                                  .signIn(email: email, password: password);

                              (user != null)
                                  ? context.goNamed(AppRouter.dashboard.name)
                                  : snackbarError(
                                      context,
                                      'Email or Password is Incorrect',
                                      darkred);
                            }
                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.5,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
