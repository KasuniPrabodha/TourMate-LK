import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please agree to the Terms of Service")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final error = await _authService.signUp(
      fullName: _nameController.text.trim(),
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please log in.")),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Image.asset('assets/app_logo1.png', width: 100, height: 100, fit: BoxFit.contain),
                  Text("TourMate LK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF134a26))),
                  Text("Create Your Account", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(
                    "Fill in your details to start planning your adventure.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 220, 218, 218).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                          child: Icon(Icons.person, size: 25, color: Color.fromARGB(255, 142, 141, 141)),
                        ),
                        Expanded(
                          // CHANGED: added controller
                          child: TextField(
                            controller: _nameController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.normal),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 220, 218, 218).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                          child: Icon(Icons.mail, size: 25, color: Color.fromARGB(255, 142, 141, 141)),
                        ),
                        Expanded(
                          // CHANGED: added controller
                          child: TextField(
                            controller: _emailController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "Email Address",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.normal),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 220, 218, 218).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                          child: Icon(Icons.lock, size: 25, color: Color.fromARGB(255, 142, 141, 141)),
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
                              hintStyle: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.normal),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 220, 218, 218).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                          child: Icon(Icons.lock, size: 25, color: Color.fromARGB(255, 142, 141, 141)),
                        ),
                        Expanded(
                          // CHANGED: added controller + obscureText
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.normal),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // CHANGED: added a clickable Checkbox right before the terms text
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          activeColor: Color(0xFF134a26),
                          onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "I agree to the Terms Of Service and Privacy Policy.",
                          style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // CHANGED: wrapped in GestureDetector, shows loading state
                  GestureDetector(
                    onTap: _isLoading ? null : _handleSignup,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(color: Color(0xFF134a26), borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("or", style: TextStyle(fontSize: 15, color: Colors.grey.shade500, fontWeight: FontWeight.w700)),
                  SizedBox(height: 20),
                  // CHANGED: wrapped in GestureDetector -> opens Google
                  GestureDetector(
                    onTap: _openGoogle,
                    child: Container(
                      width: double.infinity,
                      height: 30,
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
                            child: Text("Sign Up with Google", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // CHANGED: wrapped in GestureDetector -> opens Facebook
                  GestureDetector(
                    onTap: _openFacebook,
                    child: Container(
                      width: double.infinity,
                      height: 30,
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
                            child: Text("Sign Up with Facebook", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account!   ",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      // CHANGED: wrapped in GestureDetector -> back to LoginPage
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Color(0xFF134a26), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
