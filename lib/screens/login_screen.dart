import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks/screens/tasks_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

 
  bool _isLoading = false; 
  bool _isLogin =
      true; 

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }


  void _navigateOnSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TasksScreen()),
    );
  }


  Future<void> _submit() async {
 
    if (!_formKey.currentState!.validate()) return;

    
    setState(() => _isLoading = true);

    try {
      final auth = FirebaseAuth.instance; 

      if (_isLogin) {
       
        await auth.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(), 
          password: _passwordCtrl.text.trim(),
        );
      } else {
     
        await auth.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
      }

      _navigateOnSuccess();
    } on FirebaseAuthException catch (e) {
      
      _showError(e.message ?? 'Authentication failed.');
    } catch (e) {
      
      _showError('An unexpected error occurred.');
    } finally {
      
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Card(
            elevation: 8, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey, 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
              
                    Text(
                      _isLogin ? 'Login' : 'Register',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

             
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                      
                        if (value == null || !value.contains('@')) {
                          return 'Enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

               
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: true, 
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                   
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                       
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isLogin ? 'Login' : 'Register',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    SizedBox(height: 12),

                    
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin
                            ? "Don't have an account? Register"
                            : "Already registered? Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
