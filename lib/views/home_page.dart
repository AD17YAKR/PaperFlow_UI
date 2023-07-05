import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String?> isLoggedIn() async {
    final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    String? accessToken = await _secureStorage.read(key: 'access_token');
    return accessToken;
  }

  @override
  void initState() {
    super.initState();
    print(isLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paperflow UI'),
      ),
    );
  }
}
