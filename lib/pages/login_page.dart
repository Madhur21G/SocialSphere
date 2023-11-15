import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/components/my_buttons.dart';
import 'package:social_sphere/components/my_textfield.dart';
import 'package:social_sphere/helper/helper_function.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  // login method
  void login() async{
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordcontroller.text);

      if(context.mounted) Navigator.pop(context);
    }

    on FirebaseAuthException catch(e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),
            // app name

            const Text(
              "SOCIALSPHERE",
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 50),

            // email text field
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordcontroller,
            ),
            const SizedBox(height: 10),

            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forgot Password?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // sign in button
            MyButton(
                text: "Login",
                onTap: login,
            ),

            const SizedBox(height: 25),

            // Don't have an account? Register here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    " Register Here ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            )
          ],
      ),
        ),
      ),
    );
  }
}
