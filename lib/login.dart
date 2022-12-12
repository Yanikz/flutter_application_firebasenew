import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebasenew/main.dart';
import 'package:flutter_application_firebasenew/register.dart';
import 'package:flutter_application_firebasenew/tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  late String error;

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              Padding(
                padding: const EdgeInsets.only(left:180),
                child: Image.asset(
                  'assets/images/reddit-logo.png',
                  width: 40,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push (
                        context,
                         MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                      );
                  },
                  
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 13),
                child: Text("Log In",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By continuing, you agree to our ',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'User Agreement',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                           
                          },
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                           
                          },
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(
                color: Color.fromARGB(255, 231, 226, 226),
                
                thickness: 2,
                
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: usernamecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter username',
                    ),
                  ),
                ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter password',
                    ),
                  ),
                ),
        
              const SizedBox(
                height: 15,
              ),
             
            Container(
                  padding: const EdgeInsets.all(20),
                  
                  child: ElevatedButton.icon(
                    
                    icon: const Icon(
                      Icons.lock_open,
                    ),
                    onPressed: () {
                      signIn();
                    },
                    
                    style: ElevatedButton.styleFrom(
                      
                      minimumSize: const Size.fromHeight(50),
                     
                    ),
                    label: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ]),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernamecontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      setState(() {
        error = "";
        Fluttertoast.showToast(msg:"Login Succesfully");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Tabs()));
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
    }
    Navigator.pop(context);
  }
}
