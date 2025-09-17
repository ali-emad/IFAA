import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCvFybhWlSnaNTsPAoZLi-DsOZjnLM2ydc",
      authDomain: "ifaa-54ebf.firebaseapp.com",
      projectId: "ifaa-54ebf",
      storageBucket: "ifaa-54ebf.firebasestorage.app",
      messagingSenderId: "361540966995",
      appId: "1:361540966995:web:f91681f06ed6c79bf404a6",
      measurementId: "G-N2FBX7K8J6",
    ),
  );
  runApp(const ProviderScope(child: IFAAApp()));
}