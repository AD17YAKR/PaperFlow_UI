import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paperflow_ui/modules/auth/view/login.view.dart';
import 'package:paperflow_ui/services/api_service.dart';
import 'package:paperflow_ui/utils/colors.dart';
import 'package:paperflow_ui/modules/view_pdf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? accessToken, email, username;
  var data, sharedPdfs;
  ApiService apiService = ApiService();
  FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  Future<Map<String, dynamic>> fetchData() async {
    accessToken = await _secureStorage.read(key: 'access_token');
    email = await _secureStorage.read(key: 'email');
    username = await _secureStorage.read(key: 'username');
    data = await apiService.fetchUserDetails();
    Map<String, dynamic> result = {
      "accessToken": accessToken,
      "email": email,
      "username": username,
      "pdfs": data['pdfs']
    };
    return result;
  }

  getData() async {
    var result = await fetchData();
    setState(() {
      _isLoading = false;
    });
    ;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            initState();
          },
        ),
        title: const Text(
          'Paperflow',
          style: TextStyle(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _secureStorage.deleteAll();
              Get.to(LoginView());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: Lottie.asset("assets/loading.json"),
              ),
            )
          : ListView(
              children: [
                const Divider(
                  thickness: 3.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Your PDFs",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 3.0,
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: data['pdfs'].map<Widget>((pdf) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => PdfViewPage(
                              data: pdf,
                            ));
                      },
                      child: SizedBox(
                        width: 120,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/pdfIcon.png',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              pdf['fileName'].toString(),
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
                  }).toList(),
                ),
                const Divider(
                  thickness: 3.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Shared PDFs",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 3.0,
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: data['sharedPdfs'].map<Widget>(
                    (pdf) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => PdfViewPage(
                              data: pdf,
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/pdfIcon.png',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                pdf['fileName'].toString(),
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
                const Divider(
                  thickness: 3.0,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await apiService.uploadPdf();
          initState();
        },
        clipBehavior: Clip.antiAlias,
        backgroundColor: AppColors.buttonPrimary,
        child: const Icon(
          Icons.upload_file,
        ),
      ),
    );
  }
}
