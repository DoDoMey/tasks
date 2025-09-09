import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:tasks/providers/tasks_provider.dart';
import 'package:tasks/screens/tasks_screen.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp();

  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(
          create: (_) => TasksProvider(),
          
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: 'Tasks App', 
    
    home: FirebaseAuth.instance.currentUser == null
      
      ? LoginScreen()
      
      : TasksScreen(),
      ),
    );
  }
}
