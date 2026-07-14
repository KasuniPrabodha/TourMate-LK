import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/pages/signup_page.dart';
import 'package:final_project/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }
    setState(() => _isLoading = true);
    final error = await _authService.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _openGoogle() async {
    final uri = Uri.parse('https://www.google.com/search?q=TourMate+LK');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openFacebook() async {
    final uri = Uri.parse('https://www.facebook.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const Text(
                  "Login To Continue",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 96, 96, 96),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 220, 218, 218).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Icon(Icons.mail, size: 30, color: Color.fromARGB(255, 142, 141, 141)),
                      ),
                      Expanded(
                        // CHANGED: added controller
                        child: TextField(
                          controller: _emailController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Email Address",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 18, color: Colors.black45, fontWeight: FontWeight.normal),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 220, 218, 218).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        child: Icon(Icons.lock, size: 30, color: Color.fromARGB(255, 142, 141, 141)),
                      ),
                      Expanded(
                        // CHANGED: added controller + obscureText
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 18, color: Colors.black45, fontWeight: FontWeight.normal),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // CHANGED: "Forgot Password?" Align block removed per requirement
                SizedBox(height: 40),
                // CHANGED: wrapped in GestureDetector, shows loading state
                GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Color(0xFF134a26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Login",
                              style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('or continue with', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    // CHANGED: Expanded instead of fixed width:150, with a gap,
                    // so both boxes always fit side-by-side on any screen.
                    Expanded(
                      child: GestureDetector(
                        onTap: _openGoogle,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color.fromARGB(255, 211, 211, 211)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/google_icon.png', width: 20, height: 20, fit: BoxFit.contain),
                              Padding(
                                padding: EdgeInsetsGeometry.only(left: 10),
                                child: Text("Google", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: _openFacebook,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color.fromARGB(255, 211, 211, 211)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/facebook_icon.png', width: 20, height: 20, fit: BoxFit.contain),
                              Padding(
                                padding: EdgeInsetsGeometry.only(left: 10),
                                child: Text("Facebook", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?   ",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    // CHANGED: wrapped in GestureDetector -> navigates to SignupPage
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
                      },
                      child: Text(
                        "Sign UP",
                        style: TextStyle(color: Color(0xFF134a26), fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
