import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice/ride_request_screen.dart';
import 'package:ui_practice/ui_elements.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String? _emailError;
  String? _passwordError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign In'),
      // ),
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/bg_sign.jpg'), // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    spreadRadius: 10,
                  ),
                ],
              ),
              // color: Colors.white,
              margin: EdgeInsets.only(bottom: 20),
              height: 330,
              width: 350,
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // textField(
                    //     text: 'Email',
                    //     controller: _emailController
                    // ),
                    TextField(
                      maxLength: 32,
                      // textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        errorText: _emailError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _emailError = _validateEmail(value);
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      maxLength: 24,
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        errorText: _passwordError,
                      ),
                      obscureText: _obscureText,
                      onChanged: (value) {
                        setState(() {
                          _passwordError = _validatePassword(value);
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    FloatingActionButton.extended(
                      onPressed: () {
                        _handleSignIn();
                      },
                      label: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      icon: const Icon(Icons.login),
                      heroTag: 'sign-in',
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: const Text(
          'back ',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  bool isValidEmail(String email) {
    // Regular expression for a simple email validation
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Invalid email format';
    }
    return null; // No error
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (!isValidPassword(value)) {
      return 'Invalid Password';
    }
    return null; // No error
  }

  Future<void> _handleSignIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var headers = {'Content-Type': 'application/json'};
    var body = json
        .encode({"username": email, "password": password, "method": "sign-in"});

    final response = await http.post(
      Uri.parse(
          'https://atbcamg9e2.execute-api.us-east-1.amazonaws.com/V1/auth'),
      body: body,
      headers: headers,
    );

    var data = json.decode(response.body);
    if (data['statusCode'] == 200) {
      print(data);
      bool isAuthenticated = data['body'] != null;
      if (isAuthenticated) {
        await _storeData(true);
        // Navigate to the next screen after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RideRequestScreen()),
        );
      } else {
        // Handle authentication failure
        print('Authentication failed');
      }
    } else {
      // Handle API call failure
      print('Failed to authenticate');
    }
  }

  Future<void> _storeData(bool auth) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', auth);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SignUpScreen extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: BlocProvider(
//         create: (context) => SignUpBloc(), // Replace with your own Bloc/Cubit
//         child: SignUpForm(),
//       ),
//     );
//   }
// }
//
// class SignUpForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final signUpBloc = context.read<SignUpBloc>(); // Replace with your own Bloc/Cubit
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             onChanged: (email) => signUpBloc.add(SignUpEmailChanged(email)),
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             onChanged: (password) => signUpBloc.add(SignUpPasswordChanged(password)),
//             decoration: InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           SizedBox(height: 32),
//           TextField(
//             onChanged: (phone) => signUpBloc.add(SignUpPhoneChanged(phone)),
//             decoration: InputDecoration(labelText: 'Phone number'),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             onChanged: (name) => signUpBloc.add(SignUpNameChanged(name)),
//             decoration: InputDecoration(labelText: 'Name'),
//             obscureText: true,
//           ),
//           SizedBox(height: 32),
//           ElevatedButton(
//             onPressed: () {
//               signUpBloc.add(SignUpSubmitted(
//               ));
//             },
//             child: Text('Sign Up'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// Future<void> createAndStore(String username, String password, String phone, String name) async {
//   var headers = {'Content-Type': 'application/json'};
//   var body = json.encode({"username": username, "password": password, 'name': name, 'phone': phone});
//
//   final response = await http.post(
//     Uri.parse('https://atbcamg9e2.execute-api.us-east-1.amazonaws.com/V1/auth'),
//     body: body,
//     headers: headers,
//   );
//   var data = json.decode(response.body);
//   if (data['statusCode'] == 200) {
//     print(data);
//     bool isAuthenticated = data['body'] != null;
//     if (isAuthenticated) {
//       await _storeData(true); // Store login status in SharedPreferences
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => const SecondRoute()),
//       // );
//     } else {
//       throw Exception('Authentication failed');
//     }
//   } else {
//     throw Exception('Failed to authenticate');
//   }
// }
// Future<void> _storeData(bool auth) async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setBool('login', auth);
// }
//
//
// class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
//   SignUpBloc() : super(SignUpInitial());
//
//   @override
//   Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
//     if (event is SignUpEmailChanged) {
//       yield SignUpStateWithEmail(event.email);
//     } else if (event is SignUpPasswordChanged) {
//       yield SignUpStateWithPassword(event.password);
//     } else if (event is SignUpPhoneChanged) {
//       yield SignUpStateWithPhone(event.phone);
//     } else if (event is SignUpNameChanged) {
//       yield SignUpStateWithName(event.name);
//     } else if (event is SignUpSubmitted) {
//       // Perform the sign-up logic here using the gathered data
//       await createAndStore(email, password, phone, name);
//       yield SignUpStateSubmitted(email, password, phone, name);
//     }
//   }
// }
//
// abstract class SignUpEvent {}
//
// class SignUpEmailChanged extends SignUpEvent {
//   final String email;
//   SignUpEmailChanged(this.email);
// }
//
// class SignUpPasswordChanged extends SignUpEvent {
//   final String password;
//   SignUpPasswordChanged(this.password);
// }
//
// class SignUpPhoneChanged extends SignUpEvent {
//   final String phone;
//   SignUpPhoneChanged(this.phone);
// }
//
// class SignUpNameChanged extends SignUpEvent {
//   final String name;
//   SignUpNameChanged(this.name);
// }
//
// class SignUpSubmitted extends SignUpEvent {
// }
//
// abstract class SignUpState {}
//
// class SignUpInitial extends SignUpState {}
//
// class SignUpStateWithEmail extends SignUpState {
//   final String email;
//   SignUpStateWithEmail(this.email);
// }
//
// class SignUpStateWithPassword extends SignUpState {
//   final String password;
//   SignUpStateWithPassword(this.password);
// }
//
// class SignUpStateWithPhone extends SignUpState {
//   final String phone;
//   SignUpStateWithPhone(this.phone);
// }
//
// class SignUpStateWithName extends SignUpState {
//   final String name;
//   SignUpStateWithName(this.name);
// }
//
// class SignUpStateSubmitted extends SignUpState {
//   final String email;
//   final String password;
//   final String phone;
//   final String name;
//   SignUpStateSubmitted(this.email, this.password, this.phone, this.name);
// }
