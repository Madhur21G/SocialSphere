import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/components/my_buttons.dart';
import 'package:social_sphere/components/my_textfield.dart';
import 'package:social_sphere/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;
  const RegisterPage({super.key, required this. onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmPWcontroller = TextEditingController();

  // register method
  void registerUser() async{
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
    );

    // make sure passwords match
    if (passwordcontroller.text != confirmPWcontroller.text){
      // pop loading circle
      Navigator.pop(context);

      // show error message to the user
      displayMessageToUser(" Passwords don't match! ", context);
    }
    else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordcontroller.text);

        createUserDocument(userCredential);

        if(context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }

    // try creating the user
  }

  Future<void> createUserDocument(UserCredential? userCredential) async{

    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'email':userCredential.user!.email,
        'username':usernameController.text,
      });
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
                size: 75,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              // const SizedBox(height: 10),
              // app name

              const Text(
                "S O C I A L  S P H E R E",
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 15),

              // username text field
              MyTextField(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 10),

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

              // confirm password textfield
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPWcontroller,
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
              const SizedBox(height: 10),

              // register button
              MyButton(
                text: "Register",
                onTap: registerUser,
              ),

              const SizedBox(height: 10),

              // Don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here ",
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
