import 'package:flutter/material.dart';
import 'package:ui_practice/ride_request_screen.dart';
import 'package:ui_practice/sign_in_screen.dart';
import 'package:ui_practice/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride App',
      theme: _buildShrineTheme(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display splash screen while waiting
          } else {
            if (snapshot.hasError) {
              // Handle error case
            }
            if (snapshot.data == true) {
              return RideRequestScreen();
            } else {
              return MyHomePage(title: 'Login');
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // return false;
    //comment the previous line and un-comment the next line
    return prefs.getBool('login') ?? false;
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Display a loading indicator
            SizedBox(height: 16),
            Text("Loading..."), // Display a loading text
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var style = ElevatedButton.styleFrom(
      minimumSize: Size(160, 60),
      padding: EdgeInsets.all(12),
      elevation: 15,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Ride App'),
      // ),
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/bg_image.jpg'), // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              margin: const EdgeInsets.only(
                left: 20,
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SignInScreen();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.decelerate;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ));
                    },
                    label: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(Icons.login),
                    elevation: 15,
                    heroTag: 'sign-in',
                    // hoverElevation: 10,
                    // splashColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    label: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(Icons.assignment_ind),
                    elevation: 15,
                    heroTag: 'sign-up',
                    // splashColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  )
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => SignInScreen()),
                  //     );
                  //   },
                  //   style: style,
                  //   child: Text('Sign In',
                  //       style: TextStyle(color: Colors.white, fontSize: 28)),
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => SignUpScreen()),
                  //     );
                  //   },
                  //   style: style,
                  //   child: const Text('Sign Up',
                  //       style: TextStyle(color: Colors.white, fontSize: 28)),
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => SignUpScreen()),
                  //     );
                  //   },
                  //   child: const Text('Sign Up', style: TextStyle(fontSize: 32, color: Colors.cyan)),
                  // ),
                ],
              ))),
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    toggleableActiveColor: shrinePink400,
    hintColor: shrineBrown900,
    primaryColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    // textSelectionColor: shrinePink100,
    errorColor: shrineErrorRed,
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink400,
  secondary: shrinePink50,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFedeec9);
const Color shrinePink100 = Color(0xffdde7c7);
const Color shrinePink300 = Color(0xFFbfd8bd);
const Color shrinePink400 = Color(0xFF77bfa3);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;
