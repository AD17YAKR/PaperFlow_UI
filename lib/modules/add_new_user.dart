import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';

class AddNewUser extends StatefulWidget {
  final pdfId;
  const AddNewUser({super.key, required this.pdfId});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  ApiService apiService = ApiService();
  bool _isLoading = true;
  var data;
  Future<Map<String, dynamic>> fetchData() async {
    data = await apiService.getAllUsers();
    setState(() {
      _isLoading = false;
    });
    return data;
  }

  var res;
  Future<dynamic> addNewUser(String userId, String pdfId) async {
    res = await apiService.addNewUser(userId, pdfId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
      ),
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: Lottie.asset('assets/loading.json'),
              ),
            )
          : data.length == 0
              ? const Center(
                  child: Text('No users Found'),
                )
              : ListView(
                  children: [
                    const SizedBox(height: 10.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: data.map<Widget>(
                        (user) {
                          return GestureDetector(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to proceed?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        addNewUser(user['_id'], widget.pdfId);
                                        Get.back();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 120,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/user.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    user['username'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
    );
  }
}
