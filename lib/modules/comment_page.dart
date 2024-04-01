// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:paperflow_ui/services/api_service.dart';
import 'package:paperflow_ui/utils/colors.dart';

class CommentPage extends StatefulWidget {
  var id;

  CommentPage({super.key, required this.id});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String? accessToken, email, username;
  var data, sharedPdfs;
  ApiService apiService = ApiService();
  FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  TextEditingController _commentController = TextEditingController();
  Future<Map<String, dynamic>> fetchData() async {
    accessToken = await _secureStorage.read(key: 'access_token');
    email = await _secureStorage.read(key: 'email');
    username = await _secureStorage.read(key: 'username');
    data = await apiService.fetchPdfById(widget.id);
    return data;
  }

  Future<Map<String, dynamic>> addComment() async {
    data = await apiService.addComment(_commentController.text, widget.id);
    initState();
    return data;
  }

  var result;
  getData() async {
    result = await fetchData();
    result = result['comments'];
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

  String changeIsoStringToData(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);

    String formattedDate = DateFormat('dd-MMMM-yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            initState();
          },
        ),
        title: const Text(
          'Comments',
        ),
      ),
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: Lottie.asset("assets/loading.json"),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            result[index]['comment'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            changeIsoStringToData(
                              result[index]['createdAt'].toString(),
                            ),
                          ),
                          trailing: Text(result[index]['userDetails'][0]
                                  ['username']
                              .toString()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              labelText: 'Add a comment',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary,
                            fixedSize: const Size(100, 50),
                          ),
                          onPressed: () {
                            addComment();
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
